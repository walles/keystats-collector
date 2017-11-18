import Foundation
import Carbon
import AppKit
import os.log

var global_recorder: Recorder? = nil
let FILENAME = "/Users/johan/keystats.json"

class Recorder {
  func read_stats() -> NSDictionary {
    // Inspired by: https://stackoverflow.com/a/39688629/473672
    do {
      let jsonData = try NSData(contentsOfFile: FILENAME, options: NSData.ReadingOptions.mappedIfSafe)
      do {
        let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        return jsonResult
      } catch {
        os_log("JSON reading failed", type: .error)
      }
    } catch {
      os_log("Opening JSON file failed", type: .error)
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
    // FIXME: Write memory structure to temporary file
    // FIXME: mv tempfile.json ~/keystats.json
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
