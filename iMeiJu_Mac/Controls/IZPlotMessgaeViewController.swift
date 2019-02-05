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
    
    var id: String!
    var model: IZPlotMessageModel?
    var player: AVPlayer?
    var idx = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.showsFullScreenToggleButton = true
        episodeView.backgroundColor = .clear
        episodeView.isHidden = true
        collectionView.backgroundColors = [NSColor(calibratedWhite: 0.8 , alpha: 0.8)]
        collectionViewConfiguration()
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        network()
    }
    
    override func mouseDown(with event: NSEvent) {
        if episodeView == nil {
            return
        }
        showEpisodeView()
    }
    
    func showEpisodeView() {
        episodeView.isHidden = !episodeView.isHidden
    }
    
    @objc func playToEndTime() {
        if episodeView != nil &&
            (model?.data.zu.first?.ji.count)! > 1 &&
            idx < (model?.data.zu.first?.ji.count)!-1 {
            idx+=1
            self.collectionView.deselectAll(nil)
            self.collectionView.selectItems(at: Set(arrayLiteral: IndexPath(item: idx, section: 0)), scrollPosition: .top)
            let m = model!.data.zu.first?.ji[idx]
            playVideo(url: m!.purl, level: m!.name)
        }
    }
    
    func playVideo(url: String, level: String) {
        let item = AVPlayerItem(url: URL(string: url)!)
        self.player = AVPlayer(playerItem: item)
        self.playerView.player = self.player
        self.player?.play()
        let window = NSApplication.shared.windows.last!
        window.title =  (model?.data.name)! + " " + level
    }
    
    func network() {
        ProgressHUD.setDefaultPosition(.center)
        ProgressHUD.show()
        let provider = MoyaProvider<MoyaApi>()
        provider.request(.show(id: id!), callbackQueue: nil, progress: nil) { result in
            ProgressHUD.dismiss()
            switch result {
            case let .success(result):
                self.model = IZPlotMessageModel(fromJson: JSON(result.data))
                if self.model?.code == 0 {
                    let ji = self.model!.data.zu.first!.ji!
                    let first = ji.first!
                    self.playVideo(url: first.purl, level: first.name)
                    // 当集数数组长度为1时, 则表示当前内容无法选集, 则移除选集菜单图层
                    if ji.count == 1 {
                        self.episodeView.removeFromSuperview()
                        self.episodeView = nil
                    }else {
                        self.episodeView.isHidden = false
                    }
                    self.collectionView.reloadData()
                    // 默认选中第一集
                    self.collectionView.selectItems(at: Set(arrayLiteral: IndexPath(item: 0, section: 0)), scrollPosition: .top)
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
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        idx = indexPaths.first!.item
        let m = model!.data.zu.first?.ji[idx]
        playVideo(url: m!.purl, level: m!.name)
    }
    
}
