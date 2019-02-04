////  IZPlotMessgaeViewController.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/4.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa
import AVKit
import Moya
import SwiftyJSON

class IZPlotMessgaeViewController: NSViewController {
    
    @IBOutlet weak var playerView: AVPlayerView!
    
    @IBOutlet weak var episodeView: NSScrollView!
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var idxp = 0
    
    
    var vid: String!
    var model: IZPlotMessageModel?
    var player: AVPlayer?
    var isShow = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.showsFullScreenToggleButton = true
        episodeView.backgroundColor = .clear
        collectionView.backgroundColors = [NSColor(calibratedWhite: 0.8 , alpha: 0.8)]
        collectionViewConfiguration()
        network()
    }
    
    func showEpisodeView() {
        if isShow {
            episodeView.layer?.transform = CATransform3DMakeTranslation(episodeView.frame.size.width, 0, 0)
        }else {
            episodeView.layer?.transform = CATransform3DMakeTranslation(0, 0, 0)
        }
        isShow = !isShow
    }
    
    override func mouseDown(with event: NSEvent) {
        showEpisodeView()
    }
    
    func network() {
        ProgressHUD.setDefaultPosition(.center)
        ProgressHUD.show()
        let provider = MoyaProvider<MoyaApi>()
        provider.request(.show(vid: vid!), callbackQueue: nil, progress: nil) { result in
            ProgressHUD.dismiss()
            switch result {
            case let .success(result):
                self.model = IZPlotMessageModel(fromJson: JSON(result.data))
                if self.model!.code == 0 {
                    let v = self.model!.data.zu.first!.ji.first!
                    let item = AVPlayerItem(url: URL(string: v.purl)!)
                    self.player = AVPlayer(playerItem: item)
                    self.playerView.player = self.player
                    self.player?.play()
                    let window = NSApplication.shared.windows.last!
                    window.title =  (self.model?.data.name)! + " " + v.name
//                    self.showEpisodeView()
                    self.collectionView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func collectionViewConfiguration() {
        collectionView.collectionViewLayout = layout
        collectionView.isSelectable = true
        collectionView.register(NSNib(nibNamed: "IZEpisodeItem", bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"))
        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.register(NSNib(nibNamed:"IZMainSectionHeaderView", bundle: nil), forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "header"))
    }
    
    var layout: NSCollectionViewFlowLayout {
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 60, height: 60)
        layout.sectionInset = NSEdgeInsetsZero
        layout.minimumLineSpacing = CGFloat.leastNormalMagnitude
        layout.minimumInteritemSpacing = CGFloat.leastNormalMagnitude
        layout.sectionHeadersPinToVisibleBounds = true
        return layout
    }
    
}

extension IZPlotMessgaeViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if model?.code == 0 {
            return (model!.data.zu.first?.ji.count)!
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), for: indexPath) as! IZEpisodeItem
        let m = model!.data.zu.first?.ji[indexPath.item]
        item.setLevel(level: (m?.name)!)
        if indexPath.item == 0 {
            item.isSelected = true;
        }
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        let old = collectionView.item(at: IndexPath(item: idxp, section: 0))
        let current = collectionView.item(at: indexPaths.first!)
        old?.isSelected = false
        current?.isSelected = true
        idxp = (indexPaths.first?.item)!
        let m = model!.data.zu.first?.ji[indexPaths.first!.item]
        let p = AVPlayerItem(url: URL(string: m!.purl)!)
        self.player = AVPlayer(playerItem: p)
        self.playerView.player = self.player
        self.player?.play()
        let window = NSApplication.shared.windows.last!
        window.title =  (model?.data.name)! + " " + m!.name
    }
    
    
}
