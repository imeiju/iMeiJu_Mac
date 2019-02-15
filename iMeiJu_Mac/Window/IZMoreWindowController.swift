////  IZMoreWindowController.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/5.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

class IZMoreWindowController: NSWindowController {
    var ztid: String?
    var id: String?
    var name: String!
    override func windowDidLoad() {
        super.windowDidLoad()
        let more = IZMoreViewController(nibName: "IZMoreViewController", bundle: nil)
        if ztid == nil {
            more.id = id
        } else {
            more.ztid = ztid
        }
        more.name = name
        contentViewController = more
    }
}
