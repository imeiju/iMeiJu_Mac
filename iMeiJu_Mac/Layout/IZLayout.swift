////  IZLayout.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/11.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import AppKit
import Foundation

class IZLayout: NSObject {
    static func layout() -> NSCollectionViewFlowLayout {
        return layout(30)
    }

    static func layout(_ minimumLineSpacing: CGFloat) -> NSCollectionViewFlowLayout {
        return layout(50, minimumLineSpacing: minimumLineSpacing)
    }

    static func layout(_ margin: CGFloat, minimumLineSpacing: CGFloat) -> NSCollectionViewFlowLayout {
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 160, height: 302)
        layout.sectionInset = NSEdgeInsetsMake(0, margin, 10, margin)
        layout.minimumLineSpacing = CGFloat.leastNormalMagnitude
        layout.minimumInteritemSpacing = minimumLineSpacing
        layout.sectionHeadersPinToVisibleBounds = true
        return layout
    }
}
