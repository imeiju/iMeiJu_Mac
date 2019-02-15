////  IZCollectionHeaderView.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/3.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

class IZCollectionHeaderView: IZView {
    @IBOutlet var sectionTitle: NSTextField!

    @IBOutlet var actionButton: NSButton!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    func setSectionHeader(title: String) {
        sectionTitle.stringValue = title
    }
}
