////  IZPlotMessgaeViewController.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/4.
//    QQ群:    577506623
//    GitHub:    https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa
import AVKit
import Moya
import SwiftyJSON
import SQLite

class IZPlotMessgaeViewController: NSViewController {
    
    @IBOutlet weak var playerView: AVPlayerView!
    @IBOutlet weak var episodeView: NSScrollView!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var id: String!
    var model: IZPlotMessageModel?
    var player: AVPlayer?
    var idx = 0
    var db: Connection!
    var plot: Table!
    let pid = Expression<Int64>("pid") // 主key
    let vid = Expression<String>("vid") // 视频id
    let name = Expression<String>("name") // 视频名称
    let level = Expression<Int>("level") // 第几集
    let prate = Expression<Int64>("prate") // 视频进度
    var playing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.showsFullScreenToggleButton = true
        episodeView.backgroundColor = .clear
        episodeView.isHidden = true
        collectionView.backgroundColors = [NSColor(calibratedWhite: 0.8 , alpha: 0.8)]
        collectionViewConfiguration()
        // 监听播放完成通知,进行连播任务
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/iMeiJu.sqlite3")
            plot = Table("plot")
            try db!.run(plot!.create { t in
                t.column(pid, primaryKey: .autoincrement)
                t.column(vid)
                t.column(name)
                t.column(level)
                t.column(prate, defaultValue: 0)
            })
        }catch {
            
        }
        
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
            playVideo(url: m!.purl, levelName: m!.name, update: true)
        }
    }
    
    func playVideo(url: String, levelName: String, update: Bool?) {
        let item = AVPlayerItem(url: URL(string: url)!)
        self.player = AVPlayer(playerItem: item)
        self.playerView.player = self.player
        self.player?.play()
        let window = NSApplication.shared.windows.last!
        window.title =  (model?.data.name)! + " " + levelName
        item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        if update == true {
            do {
                let query = self.plot.filter(self.vid == self.id)
                try db.run(query.update(self.level <- idx))
            }catch {
                
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            switch self.player?.currentItem!.status {
            case .readyToPlay?:
                do {
                    if playing == false {
                        let query = self.plot.filter(self.vid == self.id)
                        let p = try self.db.pluck(query)
                        player?.seek(to: CMTime(value: p![prate], timescale: 1))
//                        player?.play()
                        playing = true
                    }
                }catch {
                    
                }
               
            case .failed?:
                //播放失败
                print("failed")
            case.unknown?:
                //未知情况
                print("unkonwn")
            case .none:
                print("none")
                break
            case .some(_):
                print("some")
                break
            }
        }
    }
    
    func network() {
        ProgressHUD.setDefaultPosition(.center)
        ProgressHUD.show()
        provider.request(.show(id: id!), callbackQueue: nil, progress: nil) { result in
            ProgressHUD.dismiss()
            switch result {
            case let .success(result):
                self.model = IZPlotMessageModel(fromJson: JSON(result.data))
                if self.model?.code == 0 {
                    let ji = self.model!.data.zu.first!.ji!
                    var v = ji[self.idx]
                    // 当集数数组长度为1时, 则表示当前内容无法选集, 则移除选集菜单图层
                    if ji.count == 1 {
                        self.episodeView.removeFromSuperview()
                        self.episodeView = nil
                    }else {
                        self.episodeView.isHidden = false
                    }
                    do {
                        let query = self.plot.filter(self.vid == self.id)
                        let p = try self.db.pluck(query)
                        if p == nil {
                            let insert = self.plot.insert(self.vid <- self.id, self.name <- v.name, self.level <- self.idx, self.prate <- 0)
                            try self.db.run(insert)
                        }else {
                            self.idx = p![self.level]
                            v = ji[self.idx]
//                            let seekTime = CMTime(value: p![self.prate], timescale: 1)
//                            self.player?.seek(to: seekTime)
                        }
                    }catch {
                        
                    }
                    self.playVideo(url: v.purl, levelName: v.name, update: false)
                    self.collectionView.reloadData()
                    self.collectionView.selectItems(at: Set(arrayLiteral: IndexPath(item: self.idx, section: 0)), scrollPosition: .top)
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
        playVideo(url: m!.purl, levelName: m!.name, update: true)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        let currentTime = player!.currentTime()
        let currentTimeNum = currentTime.value / Int64(currentTime.timescale)
        do {
            let query = self.plot.filter(self.vid == self.id)
            try db.run(query.update(self.prate <- currentTimeNum))
        }catch {
            
        }
        player?.currentItem!.removeObserver(self, forKeyPath: "status", context: nil)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
}

