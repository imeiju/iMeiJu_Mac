////  IZExtension.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/2.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa
import Foundation
@_exported import Kingfisher
@_exported import Moya
@_exported import SwiftHEXColors
@_exported import SwiftyJSON

extension NSColor {
    func randomColor() -> NSColor {
        let red = CGFloat(arc4random() % 255) / 255.0
        let green = CGFloat(arc4random() % 255) / 255.0
        let blue = CGFloat(arc4random() % 255) / 255.0
        return NSColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension NSButton {
    func setAttributedString(_ string: String, color: NSColor) {
        attributedTitle = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

extension NSImageView {
    func setImage(_ url: String) {
        kf.setImage(with: URL(string: url), placeholder: NSImage(named: "placeholder"))
    }
}

extension NSViewController {
    func jumpWindow(window: NSWindow) {
        window.setFrame(NSApplication.shared.windows.first!.frame, display: true)
        window.orderFront(nil)
    }
}
