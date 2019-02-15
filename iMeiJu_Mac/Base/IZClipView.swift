////  IZClipView.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/11.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

class IZClipView: NSClipView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor(hexString: "0C172D")!.set()
        __NSRectFillUsingOperation(dirtyRect, NSCompositingOperation.sourceOver)
    }
}
