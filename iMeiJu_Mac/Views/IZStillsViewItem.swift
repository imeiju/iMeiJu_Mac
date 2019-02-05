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
        imageView?.imageFrameStyle = NSImageView.FrameStyle.grayBezel
    }
    
    func setName(name: String) {
        textField?.stringValue = name
    }
    
    func setImageUrl(url: String) {
        imageView?.kf.indicatorType = .activity
        imageView?.setImage(url)
    }
    
}
