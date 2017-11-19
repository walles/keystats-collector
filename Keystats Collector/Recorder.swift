import Foundation
import Carbon
import AppKit
import os.log

var global_recorder: Recorder? = nil
let FILENAME = "/Users/johan/keystats.json"

class Recorder {
  func read_stats() -> Dictionary<String, Int> {
    // Inspired by: https://stackoverflow.com/a/39688629/473672
    do {
      let jsonData = try NSData(contentsOfFile: FILENAME, options: NSData.ReadingOptions.mappedIfSafe)
      do {
        let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
        return jsonResult as! Dictionary<String, Int>
      } catch {
        os_log("JSON reading failed", type: .error)
      }
    } catch {
      os_log("Opening JSON file failed", type: .error)
    }
  }

  func write_stats(_ stats: Dictionary<String, Int>) {
    // Write JSON to a temporary file
    var jsonData: Data!
    do {
      jsonData = try JSONSerialization.data(withJSONObject: stats, options: JSONSerialization.WritingOptions())
    } catch let error as NSError {
      os_log("%@", "Array to JSON conversion failed: \(error.localizedDescription)")
    }
    let file = FileHandle(forWritingAtPath: FILENAME + ".tmp")
    file!.write(jsonData)

    // Rename temp file on top of the actual destination file
    do {
      try FileManager.default.moveItem(atPath: FILENAME + ".tmp", toPath: FILENAME)
    } catch let error as NSError {
      os_log("%@", "Renaming JSON file failed: \(error.localizedDescription)")
    }
  }

  func handleKeyEvent(_ event: CGEvent, action: String) {
    if isAutorepeat(event: event) {
      return
    }
    if (action != "down") {
      return
    }

    let stats = read_stats()
    // FIXME: Update our memory structure with the keypress
    if (stats has entry for this key) {
      // FIXME: Update stats for this key
    } else {
      // FIXME: Add count of one for this key
    }
    write_stats(stats)
  }

  func handleFlagsEvent(_ event: CGEvent) {
    let keycode = keycodeOfEvent(event)
    let mask = eventFlagMaskForKeycode(Int(keycode))
    if mask == 0 {
      return
    }

    let maskedFlags = Int32(event.flags.rawValue) & mask
    handleKeyEvent(event, action: ((maskedFlags != 0) ? "down" : "up"))
  }

  func tapDidReceiveEvent(_ event: CGEvent, type: CGEventType) {
    switch type {
    case .keyDown:
      handleKeyEvent(event, action: "down")
    case .keyUp:
      handleKeyEvent(event, action: "up")
    case .flagsChanged:
      handleFlagsEvent(event)
    default:
      os_log("1Ignoring event of unsupported type", type: .debug)
    }
  }

  func run() {
    let eventMask =
      (1 << CGEventType.keyDown.rawValue) |
      (1 << CGEventType.keyUp.rawValue) |
      (1 << CGEventType.flagsChanged.rawValue)

    global_recorder = self
    guard let eventTap =
      CGEvent.tapCreate(tap: .cgAnnotatedSessionEventTap,
                        place: .headInsertEventTap,
                        options: .listenOnly,
                        eventsOfInterest: CGEventMask(eventMask),
                        callback: onTapEvent,
                        userInfo: nil) else {
                          os_log("failed to create event tap")
                          exit(1)
                        }

    let runLoopSource = CFMachPortCreateRunLoopSource(nil, eventTap, 0)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
    CGEvent.tapEnable(tap: eventTap, enable: true)
    CFRunLoopRun()

    os_log("Run loop executing")
  }
}

func onTapEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>?
{
  os_log("Johan: Got a tap event!")

  global_recorder!.tapDidReceiveEvent(event, type: type)

  // FIXME: Retained vs unretained, which is it?
  return Unmanaged.passUnretained(event)
}

func keycodeOfEvent(_ event: CGEvent) -> Int {
  return Int(event.getIntegerValueField(.keyboardEventKeycode))
}

func keynameOfEvent(event: CGEvent) -> String {
  return keynameForKeycode[keycodeOfEvent(event)] ?? "<UNKNOWN>"
}

func isAutorepeat(event: CGEvent) -> Bool {
  return 0 != event.getIntegerValueField(.keyboardEventAutorepeat)
}
