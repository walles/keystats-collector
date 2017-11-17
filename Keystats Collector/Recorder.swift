import Foundation
import Carbon
import AppKit
import os.log

class Recorder {
  func handleKeyEvent(_ event: CGEvent, action: String) {
    if isAutorepeat(event: event) {
      return
    }
    let string = """
      data:{"action":"\(action)","key":"\(keynameOfEvent(event: event))"}


      """.utf8CString

    // FIXME: Update our JSON file here
    os_log("Johan: %@", [string])
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
      os_log("Ignoring non-key-event", type: .debug)
    }
  }

  func run() {
    let eventMask =
      (1 << CGEventType.keyDown.rawValue) |
      (1 << CGEventType.keyUp.rawValue) |
      (1 << CGEventType.flagsChanged.rawValue)

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
  }
}

func onTapEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
  if [.keyDown , .keyUp].contains(type) {
    var keyCode = event.getIntegerValueField(.keyboardEventKeycode)
    if keyCode == 0 {
      keyCode = 6
    } else if keyCode == 6 {
      keyCode = 0
    }
    event.setIntegerValueField(.keyboardEventKeycode, value: keyCode)
  }
  return Unmanaged.passRetained(event)
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
