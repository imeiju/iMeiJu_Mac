////  IZSearchViewController.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/5.
//    QQ群:    577506623
//    GitHub:    https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

class IZSearchViewController: NSViewController {
    @IBOutlet var wordsBackgroundView: NSView!
    @IBOutlet var words: NSSearchField!
    @IBOutlet var collectionView: NSCollectionView!

    var model: IZMoreModel?

    override func viewDidLoad() {
        super.viewDidLoad()
//        words.isHidden = true

        words.focusRingType = .none
        words.delegate = self
        words.layer?.cornerRadius = words.bounds.size.height / 2
        words.layer?.masksToBounds = true
        words.layer?.borderColor = NSColor.white.cgColor
        words.layer?.borderWidth = 3
        words.resignFirstResponder()

//        if NSPasteboard.general.string(forType: .string) != nil {
//            words.stringValue = NSPasteboard.general.string(forType: .string)!
//        }

        collectionViewConfiguration()
    }

    func network() {
        
        provider.request(.search(key: words.stringValue, page: "1", size: "10000")) { result in
            
            switch result {
            case let .success(result):
                self.model = IZMoreModel(fromJson: JSON(result.data))
                self.collectionView.reloadData()
            case .failure:
                break
            }
        }
    }

    func collectionViewConfiguration() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = IZLayout.layout(40, minimumLineSpacing: 40)
        collectionView.isSelectable = true
        collectionView.register(NSNib(nibNamed: "IZStillsViewItem", bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"))
    }
}

extension IZSearchViewController: NSCollectionViewDelegate, NSCollectionViewDataSource, NSSearchFieldDelegate {
    func control(_: NSControl, textView _: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if !words.stringValue.isEmpty, commandSelector == #selector(insertNewline) { // 监听键盘的回车事件.
            network()
            return true
        }
        return false
    }

    func collectionView(_: NSCollectionView, numberOfItemsInSection _: Int) -> Int {
        if model?.code == 0 {
            return (model?.data.count)!
        }
        return 0
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), for: indexPath) as! IZStillsViewItem
        let m = model!.data[indexPath.item]
        item.setName(m.name)
        item.setImageUrl(m.pic)
        return item
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        // 消除选中状态,使其可以再次选择
        collectionView.deselectItems(at: indexPaths)
        let m = model!.data[indexPaths.first!.item]
        let plot = IZPlotMessgaeWindowController(windowNibName: "IZPlotMessgaeWindowController")
        plot.id = m.id
        plot.name = m.name
        jumpWindow(window: plot.window!)
    }
}
