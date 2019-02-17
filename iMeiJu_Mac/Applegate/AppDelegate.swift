////  AppDelegate.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/2.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
//    @IBOutlet var vip: NSMenuItem!

    func applicationDidFinishLaunching(_: Notification) {
//        if UserDefaults.standard.bool(forKey: "isVip") {
//            vip.state = .on
//        }

        // 打开时进行后台检查是否有新版本
//        SUUpdater.shared()?.checkForUpdatesInBackground()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        return true
    }

    @IBAction func github(_: Any) {
        NSWorkspace().open(NSURL(string: "https://github.com/imeiju/iMeiJu_Mac")! as URL)
    }

//    @IBAction func vip(_ sender: NSMenuItem) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isVip"), object: nil)
//        if sender.state == .off {
//            sender.state = .on
//            UserDefaults.standard.set(true, forKey: "isVip")
//        } else {
//            sender.state = .off
//            UserDefaults.standard.set(false, forKey: "isVip")
//        }
//    }
}
