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
    }
    
    func setLevel(level: String) {
        textField?.stringValue = level
    }
 
    override var isSelected: Bool{
        willSet{
            
        }
        didSet{
            if isSelected {
                textField?.textColor = .black
            }else {
                textField?.textColor = .white
            }
        }
    }
    
    

    
    
//    override var isSelected: Bool
    
}
