////  AppDelegate.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/2.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa
import LeanCloud

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        LCApplication.default.set(
            id: "qj9kTLJ0kBsXtgO4YMHzz2Kk-gzGzoHsz",
            key: "mHTCgzN4C68oCduACJjon4PI"
        )
        update(Any.self)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        return true
    }

    @IBAction func github(_: Any) {
        NSWorkspace().open(NSURL(string: "https://github.com/imeiju/iMeiJu_Mac")! as URL)
    }

    @IBAction func update(_: Any) {
        let query = LCQuery(className: "mac")
        _ = query.get("5c5c39d844d90424cf9acaa9") { result in
            switch result {
            case let .success(object: object):
                if (object.get("version")?.floatValue)! > Float(1.3) {
                    if object.get("forceUpdate")!.intValue! == 1 {
                        let alert = NSAlert()
                        alert.messageText = object.get("title")!.stringValue!
                        alert.informativeText = object.get("subTitle")!.stringValue!
                        alert.addButton(withTitle: object.get("confirm")!.stringValue!)
                        alert.alertStyle = .warning
                        alert.beginSheetModal(for: NSApplication.shared.keyWindow!) { _ in
                            self.github(Any.self)
                            exit(0)
                        }
                        //                    alert.runModal()
                    } else if object.get("update")!.intValue! == 1 {
                        let alert = NSAlert()
                        alert.messageText = object.get("title")!.stringValue!
                        alert.informativeText = object.get("subTitle")!.stringValue!
                        alert.addButton(withTitle: object.get("confirm")!.stringValue!)
                        alert.addButton(withTitle: "取消")
                        alert.alertStyle = .informational
                        alert.beginSheetModal(for: NSApplication.shared.keyWindow!, completionHandler: { finished in
                            switch finished.rawValue {
                            case 1000:
                                self.github(Any.self)
                            default:
                                break
                            }
                        })
                    }
                    break
                }
            case .failure(error: _):
                // handle error
                break
            }
        }
    }
}

// switch finished {
// case .OK:
// break
// case .cancel:
// break
//                        if (finished == NSNSApplication.ModalResponse.OK,
//                            print("(returnCode == NSOKButton)");
//                        }else if (returnCode == NSModalResponseCancel){
//                            print("(returnCode == NSCancelButton)");
//                        }else if(returnCode == NSAlertFirstButtonReturn){
//                            print("if (returnCode == NSAlertFirstButtonReturn)");
//                        }else if (returnCode == NSAlertSecondButtonReturn){
//                            print("else if (returnCode == NSAlertSecondButtonReturn)");
//                        }else if (returnCode == NSAlertThirdButtonReturn){
//                            print("else if (returnCode == NSAlertThirdButtonReturn)");
//                        }else{
//                            print("All Other return code %ld",(long)returnCode);
//                        }
// default: break

// }
