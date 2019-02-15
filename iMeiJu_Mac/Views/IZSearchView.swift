////  IZSearchView.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/12.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

class IZSearchView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let gradient = NSGradient(starting: NSColor(hexString: "5CBAE8")!, ending: NSColor(hexString: "71E3DE")!)
        let path = NSBezierPath(roundedRect: dirtyRect, xRadius: 20, yRadius: 20)
        gradient?.draw(in: path, angle: 90)
    }
}
