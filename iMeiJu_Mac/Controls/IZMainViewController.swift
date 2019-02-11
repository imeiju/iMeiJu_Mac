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
    case television = 2
    case search = 3
}

class IZMainViewController: NSViewController {
    
    @IBOutlet weak var menusView: IZMenusView!
    
    @IBOutlet var collectionView: NSCollectionView!
    @IBOutlet var recommend: NSButton!
    @IBOutlet var movie: NSButton!
    @IBOutlet var television: NSButton!
    @IBOutlet weak var search: NSButton!
    @IBOutlet weak var setting: NSButton!
    
    var model: IZMainModel?
    var api = MoyaApi.index(vsize: "15")
    var isZtid = true
    var isMenu = MenuType.recommend

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommend.setAttributedString("推荐", color: .white)
        movie.setAttributedString("电影", color: .white)
        television.setAttributedString("美剧", color : .white)
        search.setAttributedString("搜索", color: .white)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(search(_:)), name: NSNotification.Name(rawValue: "search"), object: nil)
        view.wantsLayer = true
        if UserDefaults.standard.bool(forKey: "isVip") {
//            vip.state = NSControl.StateValue.on
        }
        windowConfiguration()
        collectionViewConfiguration()
        
        // 默认选择推荐
        recommend(recommend)
        
    }

    @IBAction func recommend(_ sender: NSButton) {
        sender.image = NSImage(named: "recommend_select")
        movie.image = NSImage(named: "movie")
        television.image = NSImage(named: "television")
        search.image = NSImage(named: "search")
        api = .index(vsize: "15")
        isZtid = true
        isMenu = .recommend
        network()
    }

    @IBAction func movie(_ sender: NSButton) {
        sender.image = NSImage(named: "movie_select")
        recommend.image = NSImage(named: "recommend")
        television.image = NSImage(named: "television")
        search.image = NSImage(named: "search")
        api = .movie(id: "1", vsize: "15")
        isZtid = false
        isMenu = .movie
        network()
    }

    @IBAction func television(_ sender: NSButton) {
        sender.image = NSImage(named: "television_select")
        recommend.image = NSImage(named: "recommend")
        movie.image = NSImage(named: "movie")
        search.image = NSImage(named: "search")
        api = .movie(id: "2", vsize: "15")
        isZtid = false
        isMenu = .television
        network()
    }

    @IBAction func search(_ sender: NSButton) {
        sender.image = NSImage(named: "search_select")
        recommend.image = NSImage(named: "recommend")
        movie.image = NSImage(named: "movie")
        television.image = NSImage(named: "television")
        let search = IZSearchWindowContoller(windowNibName: "IZSearchWindowContoller")
        jumpWindow(window: search.window!, name: "搜索")
    }
    
    
    @IBAction func vip(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state, forKey: "isVip")
        collectionView.reloadData()
    }

    @objc func refresh() {
        network()
    }

    func windowConfiguration() {
        let window = NSApplication.shared.windows.first
        var frame = window?.frame
        frame?.size.width = 800
        frame?.size.height = 600
        window?.setFrame(frame!, display: true)
        
    }

    func network() {
        ProgressHUD.setDefaultPosition(.center)
        ProgressHUD.show()
        provider.request(api) { result in
            ProgressHUD.dismiss()
            switch result {
            case let .success(result):
                let json = JSON(result.data)
                self.model = IZMainModel(fromJson: json)
                self.collectionView.reloadData()
                // 刷新完成后 回滚到顶部
                self.collectionView.scroll(NSPoint(x: 0, y: 0))
            case .failure: break
            }
        }
    }

    func collectionViewConfiguration() {
        collectionView.collectionViewLayout = IZLayout.layout()
        collectionView.isSelectable = true
        collectionView.register(NSNib(nibNamed: "IZStillsViewItem", bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"))
        collectionView.register(NSNib(nibNamed: "IZMainSectionHeaderView", bundle: nil), forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "header"))
    }
    
    override func viewDidDisappear() {
        ProgressHUD.dismiss()
    }
    
}

extension IZMainViewController: NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    func numberOfSections(in _: NSCollectionView) -> Int {
        if model?.code == 0 {
            if isMenu == MenuType.movie, !UserDefaults.standard.bool(forKey: "isVip") {
                return (model?.data.count)! - 1
            }
            return (model?.data.count)!
        }
        return 0
    }

    func collectionView(_: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return (model?.data?[section].vod.count)!
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), for: indexPath) as! IZStillsViewItem
        let m = model!.data[indexPath.section].vod![indexPath.item]
        item.setName(m.name)
        item.setImageUrl(m.pic)
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
        } else {
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

    func collectionView(_: NSCollectionView, layout _: NSCollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> NSSize {
        return NSSize(width: view.frame.size.width, height: 44)
    }
    
}
