////  IZEpisodeItem.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/4.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

class IZEpisodeItem: NSCollectionViewItem {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.cornerRadius = 4
        view.layer?.masksToBounds = true
        view.layer?.borderWidth = 1
        view.layer?.borderColor = NSColor(hexString: "FFFFFF", alpha: 0.6)?.cgColor
    }

    func setLevel(level: String) {
        textField?.stringValue = level
    }

    override var isSelected: Bool {
        willSet {}
        didSet {
            if isSelected {
                textField?.textColor = NSColor(hexString: "71E3DE")
                view.layer?.borderColor = NSColor(hexString: "71E3DE", alpha: 0.6)?.cgColor
            } else {
                textField?.textColor = NSColor(hexString: "FFFFFF")
                view.layer?.borderColor = NSColor(hexString: "FFFFFF", alpha: 0.6)?.cgColor
            }
        }
    }
}
