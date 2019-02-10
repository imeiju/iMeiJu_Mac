////  IZMainSectionHeaderView.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/3.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

class IZMainSectionHeaderView: NSView {
    @IBOutlet var sectionTitle: NSTextField!

    @IBOutlet var actionButton: NSButton!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor(calibratedWhite: 0.8, alpha: 0.8).set()
        __NSRectFillUsingOperation(dirtyRect, NSCompositingOperation.sourceOver)
    }

    func setSectionHeader(title: String) {
        sectionTitle.stringValue = title
    }
}
