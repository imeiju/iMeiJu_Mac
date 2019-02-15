////  IZStillsViewItem.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/5.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

class IZStillsViewItem: NSCollectionViewItem {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        textField?.textColor = NSColor(hexString: "D8D8D8")
        textField?.maximumNumberOfLines = 0
        imageView?.imageAlignment = .alignCenter
        imageView?.imageScaling = .scaleAxesIndependently
//        imageView?.imageFrameStyle = NSImageView.FrameStyle.grayBezel
    }

    func setName(_ name: String) {
        var str = name
        if name.count >= 20 {
            var prefix = name.prefix(20)
            str = str.replacingOccurrences(of: prefix, with: prefix + "\n")
            prefix = name.prefix(10)
            str = str.replacingOccurrences(of: prefix, with: prefix + "\n")
        } else if name.count >= 10 {
            let prefix = name.prefix(10)
            str = str.replacingOccurrences(of: prefix, with: prefix + "\n")
        }
        textField?.stringValue = str
    }

    func setImageUrl(_ url: String) {
        imageView?.kf.indicatorType = .activity
        imageView?.setImage(url)
    }
}
