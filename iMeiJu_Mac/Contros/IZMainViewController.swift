////  IZMainViewController.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/2.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa
import Moya
import SwiftyJSON


class IZMainViewController: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    var model: IZMainModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        windowConfiguration()
        collectionViewConfiguration()
        network()
    }
    
    func windowConfiguration() {
        let window = NSApplication.shared.windows.first
        var frame = window?.frame
        frame?.size.width = 1002
        window?.setFrame(frame!, display: true)
    }
    
    func collectionViewConfiguration() {
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NSNib(nibNamed: "IZMainViewItem", bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"))
    }
    
    func network() {
        let provider = MoyaProvider<MoyaApi>()
        provider.request(MoyaApi.index(vsize: "15"), callbackQueue: nil, progress: nil) { (result) in
            switch result {
            case let .success(result):
                let json = JSON(result.data)
                self.model = IZMainModel(fromJson: json)
                self.collectionView.reloadData()
                break
            case .failure(_): break
                
            }
        }
    }
    
    var layout: NSCollectionViewFlowLayout {
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 200, height: 260)
        layout.sectionInset = NSEdgeInsetsZero
        layout.minimumLineSpacing = CGFloat.leastNormalMagnitude
        layout.minimumInteritemSpacing = CGFloat.leastNormalMagnitude
        return layout
    }
    
}

extension IZMainViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        if model?.code==0 {
            print(model?.data.count as Any)
            return (model?.data.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return (model?.data?[section].vod.count)!
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), for: indexPath) as! IZMainViewItem
        let m = model?.data[indexPath.section].vod![indexPath.item]
        item.setName(name: m!.name)
        item.setImageUrl(url: m!.pic)
        return item
    }
    
    
}
