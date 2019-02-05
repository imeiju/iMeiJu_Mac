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

enum MenuType: Int {
    case recommend = 0
    case movie = 1
    case usMovie = 2
}

class IZMainViewController: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var vip: NSButton!
    @IBOutlet weak var recommend: NSButton!
    @IBOutlet weak var movie: NSButton!
    @IBOutlet weak var usMovie: NSButton!
    
    var model: IZMainModel?
    var api = MoyaApi.index(vsize: "15")
    var isZtid = true
    var isMenu = MenuType.recommend
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        view.wantsLayer = true
        if UserDefaults.standard.bool(forKey: "isVip") {
            vip.state = NSControl.StateValue.on
        }
        vip.isHidden = true
        recommend.isEnabled = false
        windowConfiguration()
        collectionViewConfiguration()
        network()
    }
    
    @IBAction func recommend(_ sender: NSButton) {
        vip.isHidden = true
        sender.isEnabled = false
        movie.isEnabled = true
        usMovie.isEnabled = true
        api = .index(vsize: "15")
        isZtid = true
        isMenu = .recommend
        network()
    }
    
    @IBAction func movie(_ sender: NSButton) {
        vip.isHidden = false
        sender.isEnabled = false
        recommend.isEnabled = true
        usMovie.isEnabled = true
        api = .movie(id: "1", vsize: "15")
        isZtid = false
        isMenu = .movie
        network()
    }
    
    @IBAction func usMove(_ sender: NSButton) {
        vip.isHidden = true
        sender.isEnabled = false
        movie.isEnabled = true
        recommend.isEnabled = true
        api = .movie(id: "2", vsize: "15")
        isZtid = false
        isMenu = .usMovie
        network()
    }
    
    @IBAction func vip(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state, forKey: "isVip")
        self.collectionView.reloadData()
    }
    
    
    @objc func refresh() {
        network()
    }
    
    func windowConfiguration() {
        let window = NSApplication.shared.windows.first
        var frame = window?.frame
        frame?.size.width = 1002
        frame?.size.height = 600
        window?.setFrame(frame!, display: true)
    }
    
    func network() {
        ProgressHUD.setDefaultPosition(.center)
        ProgressHUD.show()
        provider.request(api, callbackQueue: nil, progress: nil) { (result) in
            ProgressHUD.dismiss()
            switch result {
            case let .success(result):
                let json = JSON(result.data)
                self.model = IZMainModel(fromJson: json)
                self.collectionView.reloadData()
                //刷新完成后 回滚到顶部
                self.collectionView.scrollToItems(at: Set(arrayLiteral: IndexPath(item: 0, section: 0)), scrollPosition: .top)
                break
            case .failure(_): break
                
            }
        }
    }
    
    func collectionViewConfiguration() {
        collectionView.collectionViewLayout = layout
        collectionView.isSelectable = true
        collectionView.register(NSNib(nibNamed: "IZStillsViewItem", bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"))
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
            if isMenu == MenuType.movie && !UserDefaults.standard.bool(forKey: "isVip") {
               return (model?.data.count)!-1
            }
            return (model?.data.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return (model?.data?[section].vod.count)!
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), for: indexPath) as! IZStillsViewItem
        let m = model!.data[indexPath.section].vod![indexPath.item]
        item.setName(name: m.name)
        item.setImageUrl(url: m.pic)
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
        let m = model!.data[sender.tag]
        let more = IZMoreWindowController(windowNibName: "IZMoreWindowController")
        if isZtid {
            more.ztid = m.id
        }else {
            more.id = m.id
        }
        jumpWindow(window: more.window!, name: m.name)
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        // 消除选中状态,使其可以再次选择
        collectionView.deselectItems(at: indexPaths)
        let m = model!.data[indexPaths.first!.section].vod![indexPaths.first!.item]
        let plot = IZPlotMessgaeWindowController(windowNibName: "IZPlotMessgaeWindowController")
        plot.id = m.id
        jumpWindow(window: plot.window!, name: m.name)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: 1002, height: 40)
    }
    
}
