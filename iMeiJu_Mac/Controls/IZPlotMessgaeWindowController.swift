////  IZPlotMessgaeWindowController.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/4.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

class IZPlotMessgaeWindowController: NSWindowController {

    var vid: String?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        let plot = IZPlotMessgaeViewController.init(nibName: "IZPlotMessgaeViewController", bundle: nil)
        plot.vid = vid
        contentViewController = plot
    }
    
}
