////  IZMenusView.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/11.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

class IZMenusView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor(hexString: "172142")!.set()
        __NSRectFillUsingOperation(dirtyRect, NSCompositingOperation.sourceOver)
    }
}
