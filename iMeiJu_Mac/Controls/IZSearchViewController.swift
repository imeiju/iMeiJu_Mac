////  IZSearchViewController.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/5.
//    QQ群:    577506623
//    GitHub:    https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa
import Moya
import SwiftyJSON

class IZSearchViewController: NSViewController {
    
    @IBOutlet weak var words: NSSearchField!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var model: IZMoreModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        words.focusRingType = .none
        words.delegate = self
        if (NSPasteboard.general.string(forType: .string) != nil) {
            words.stringValue = NSPasteboard.general.string(forType: .string)!
        }
        collectionViewConfiguration()
    }
    
    func network() {
        ProgressHUD.setDefaultPosition(.center)
        ProgressHUD.show()
        provider.request(MoyaApi.search(key: words.stringValue, page: "1", size: "10000"), callbackQueue: nil, progress: nil) { result in
            ProgressHUD.dismiss()
            switch result{
            case let .success(result):
                self.model = IZMoreModel(fromJson: JSON(result.data))
                self.collectionView.reloadData()
                break
            case .failure(_):
                break
            }
        }
    }
    
    func collectionViewConfiguration() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView.isSelectable = true
        collectionView.register(NSNib(nibNamed: "IZStillsViewItem", bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"))
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

extension IZSearchViewController: NSCollectionViewDelegate, NSCollectionViewDataSource, NSSearchFieldDelegate {
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if !words.stringValue.isEmpty && commandSelector == #selector(insertNewline) {// 监听键盘的回车事件.
            network()
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if model?.code == 0 {
            return (model?.data.count)!
        }
        return 0;
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), for: indexPath) as! IZStillsViewItem
                let m = model!.data[indexPath.item]
                item.setName(name: m.name)
                item.setImageUrl(url: m.pic)
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        // 消除选中状态,使其可以再次选择
        collectionView.deselectItems(at: indexPaths)
        let m = model!.data[indexPaths.first!.item]
        let plot = IZPlotMessgaeWindowController(windowNibName: "IZPlotMessgaeWindowController")
        plot.id = m.id
        jumpWindow(window: plot.window!, name: m.name)
    }
    
}

