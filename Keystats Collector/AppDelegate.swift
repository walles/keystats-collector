//
//  AppDelegate.swift
//  Keystats Collector
//
//  Created by Johan Walles on 2017-11-17.
//  Copyright © 2017 Johan Walles. All rights reserved.
//

import Cocoa
import os.log

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  @IBOutlet weak var window: NSWindow!

  func enableUniversalAccess() {
    let options : NSDictionary =
      [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
    if (!AXIsProcessTrustedWithOptions(options)) {
      // In theory the user should now be prompted for access
      os_log("Universal Access not enabled", type: .info)
    }
  }

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    enableUniversalAccess()
    Recorder().run()
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
}
