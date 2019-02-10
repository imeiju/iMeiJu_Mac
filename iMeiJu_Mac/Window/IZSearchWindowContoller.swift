////  IZSearchWindowContoller.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/5.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

class IZSearchWindowContoller: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        let search = IZSearchViewController(nibName: "IZSearchViewController", bundle: nil)
        contentViewController = search
    }
}
