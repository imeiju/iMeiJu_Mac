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

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    @IBAction func refresh(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    
    @IBAction func search(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "search"), object: nil)
    }
    
    
}

