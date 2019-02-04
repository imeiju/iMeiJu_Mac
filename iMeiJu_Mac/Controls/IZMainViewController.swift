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
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        view.wantsLayer = true
        windowConfiguration()
        collectionViewConfiguration()
        network()
    }
    
    @objc func refresh() {
        network()
    }
    
    func windowConfiguration() {
        let window = NSApplication.shared.windows.first
        var frame = window?.frame
        frame?.size.width = 1002
        window?.setFrame(frame!, display: true)
    }
    
    func network() {
        ProgressHUD.setDefaultPosition(.center)
        ProgressHUD.show()
        let provider = MoyaProvider<MoyaApi>()
        provider.request(MoyaApi.index(vsize: "15"), callbackQueue: nil, progress: nil) { (result) in
            ProgressHUD.dismiss()
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
    
    func collectionViewConfiguration() {
        collectionView.collectionViewLayout = layout
        collectionView.isSelectable = true
        collectionView.register(NSNib(nibNamed: "IZMainViewItem", bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"))
        collectionView.register(NSNib(nibNamed:"IZMainSectionHeaderView", bundle: nil), forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "header"))
    }
    
    var layout: NSCollectionViewFlowLayout {
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 200, height: 260)
        layout.sectionInset = NSEdgeInsetsZero
        layout.minimumLineSpacing = CGFloat.leastNormalMagnitude
        layout.minimumInteritemSpacing = CGFloat.leastNormalMagnitude
        layout.sectionHeadersPinToVisibleBounds = true
        return layout
    }
    
}

extension IZMainViewController: NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        if model?.code==0 {
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
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        let headView = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "header"), for: indexPath) as! IZMainSectionHeaderView
        headView.actionButton.target = self
        headView.actionButton.action = #selector(headViewDidSelect(sender:))
        headView.actionButton.tag = indexPath.section
        headView.setSectionHeader(title: (model?.data[indexPath.section].name)!)
        return headView
    }

    @objc func headViewDidSelect(sender: NSButton) {
        print(model?.data[sender.tag].id as Any)
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        let m = model?.data[indexPaths.first!.section].vod![indexPaths.first!.item]
        let plot = IZPlotMessgaeWindowController(windowNibName: "IZPlotMessgaeWindowController")
        plot.vid = m?.id
        plot.window!.title = (m?.name)!
        plot.window?.orderFront(nil)
        plot.window?.setFrame((NSApplication.shared.windows.first?.frame)!, display: true)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: 1002, height: 40)
    }
    
}
