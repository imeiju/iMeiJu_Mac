////  IZWindow.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/3.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

class IZWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect,
                   styleMask: style,
                   backing: backingStoreType,
                   defer: flag)
        backgroundColor = NSColor(hexString: "0C172D")!
        isMovableByWindowBackground = true
        let resize = standardWindowButton(NSWindow.ButtonType.zoomButton)
        resize?.isHidden = true
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        backingType = .buffered
    }
}
