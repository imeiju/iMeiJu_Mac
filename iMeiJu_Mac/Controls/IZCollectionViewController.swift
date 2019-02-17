////  IZCollectionViewController.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/12.
//    QQ群:    577506623
//    GitHub:    https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

class IZCollectionViewController: NSViewController {
    @IBOutlet var collectionView: IZCollectionView!

    var isZtid: Bool!
    var isMenu: MenuType!
    var api: MoyaApi!
    var model: IZMainModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        if isMenu == .movie {
            NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "isVip"), object: nil)
        }

        collectionViewConfiguration()
        network()
    }

    @objc func reloadData() {
        collectionView.reloadData()
    }

    func collectionViewConfiguration() {
        collectionView.collectionViewLayout = IZLayout.layout()
        collectionView.isSelectable = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NSNib(nibNamed: "IZStillsViewItem", bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"))
        collectionView.register(NSNib(nibNamed: "IZCollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "header"))
    }

    func network() {
        
        provider.request(api) { result in
            
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

    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        if isMenu == .movie {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "isVip"), object: nil)
        }
    }
}

extension IZCollectionViewController: NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
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
        let headView = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "header"), for: indexPath) as! IZCollectionHeaderView
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
        more.name = m.name
        jumpWindow(window: more.window!)
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        // 消除选中状态,使其可以再次选择
        collectionView.deselectItems(at: indexPaths)
        let m = model!.data[indexPaths.first!.section].vod![indexPaths.first!.item]
        let plot = IZPlotMessgaeWindowController(windowNibName: "IZPlotMessgaeWindowController")
        plot.id = m.id
        plot.name = m.name
        jumpWindow(window: plot.window!)
    }

    func collectionView(_: NSCollectionView, layout _: NSCollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> NSSize {
        return NSSize(width: view.frame.size.width, height: 44)
    }
}
