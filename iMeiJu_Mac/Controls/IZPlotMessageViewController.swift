////  IZPlotMessageViewController.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/4.
//    QQ群:    577506623
//    GitHub:    https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import AVKit
import Cocoa
import SQLite

class IZPlotMessageViewController: NSViewController {
    @IBOutlet var titleLabel: NSTextField!
    @IBOutlet var showEpisode: NSButton!
    @IBOutlet var fold: NSButton!
    @IBOutlet var playerView: AVPlayerView!
    @IBOutlet var episodeView: NSScrollView!
    @IBOutlet var collectionView: NSCollectionView!
    @IBOutlet var episodeWidth: NSLayoutConstraint!

    // 选集菜单
    let iz_width: CGFloat = 332

    var plotName: String!

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
        episodeView.backgroundColor = .clear
        episodeView.isHidden = true
        showEpisode.isHidden = true
        fold.isHidden = true

        titleLabel.stringValue = plotName
        titleLabel.textColor = NSColor(hexString: "D8D8D8")
        showEpisode.setAttributedString("选集", color: NSColor(hexString: "D8D8D8")!)

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
        } catch {}

        network()
    }

    override func mouseDown(with _: NSEvent) {
//        showEpisodeView(NSButton())
    }

    @IBAction func fold(_: Any) {
        showEpisodeView(NSButton())
    }

    @IBAction func showEpisodeView(_: NSButton) {
        if episodeView == nil {
            return
        }
        NSAnimationContext.runAnimationGroup { context in
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            if episodeWidth.constant == 0 {
                episodeWidth.animator().constant = iz_width
            } else {
                episodeWidth.animator().constant = 0
            }
        }
    }

    @objc func playToEndTime() {
        if episodeView != nil,
            (model?.data.zu.first?.ji.count)! > 1,
            idx < (model?.data.zu.first?.ji.count)! - 1 {
            idx += 1
            collectionView.deselectAll(nil)
            collectionView.selectItems(at: Set(arrayLiteral: IndexPath(item: idx, section: 0)), scrollPosition: .top)
            let m = model!.data.zu.first?.ji[idx]
            playVideo(url: m!.purl, levelName: m!.name, update: true)
        }
    }

    func playVideo(url: String, levelName: String, update: Bool?) {
        let item = AVPlayerItem(url: URL(string: url)!)
        player = AVPlayer(playerItem: item)
        playerView.player = player
        player?.play()
        titleLabel.stringValue = (model?.data.name)! + " " + levelName
        item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        if update == true {
            do {
                let query = plot.filter(vid == id)
                try db.run(query.update(level <- idx))
            } catch {}
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of _: Any?, change _: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            switch player?.currentItem!.status {
            case .readyToPlay?:
                do {
                    if playing == false {
                        let query = plot.filter(vid == id)
                        let p = try db.pluck(query)
                        player?.seek(to: CMTime(value: p![prate], timescale: 1))
                        //                        player?.play()
                        playing = true
                    }
                } catch {}

            case .failed?:
                // 播放失败
                print("failed")
            case .unknown?:
                // 未知情况
                print("unkonwn")
            case .none:
                print("none")
            case .some:
                print("some")
            }
        }
    }

    func network() {
        provider.request(.show(id: id!)) { result in
            switch result {
            case let .success(result):
                self.model = IZPlotMessageModel(fromJson: JSON(result.data))
                if self.model?.code == 0 {
                    let ji = self.model!.data.zu.first!.ji!
                    var v = ji[self.idx]
                    // 当集数数组长度为1时, 则表示当前内容无法选集, 则移除选集菜单图层
                    if ji.count == 1 {
                        self.episodeView.removeFromSuperview()
                        self.showEpisode.removeFromSuperview()
                        self.fold.removeFromSuperview()
                        self.episodeView = nil
                        self.showEpisode = nil
                        self.fold = nil
                    } else {
                        self.showEpisode.isHidden = false
                        self.episodeView.isHidden = false
                        self.fold.isHidden = false
                    }
                    do {
                        let query = self.plot.filter(self.vid == self.id)
                        let p = try self.db.pluck(query)
                        if p == nil {
                            let insert = self.plot.insert(self.vid <- self.id, self.name <- v.name, self.level <- self.idx, self.prate <- 0)
                            try self.db.run(insert)
                        } else {
                            self.idx = p![self.level]
                            v = ji[self.idx]
                        }
                    } catch {}
                    self.playVideo(url: v.purl, levelName: v.name, update: false)
                    self.collectionView.reloadData()
                    self.collectionView.selectItems(at: Set(arrayLiteral: IndexPath(item: self.idx, section: 0)), scrollPosition: .top)
                }
            case .failure:
                break
            }
        }
    }

    func collectionViewConfiguration() {
        collectionView.backgroundColors = ([NSColor(hexString: "0C172D", alpha: 0.6)] as! [NSColor])
        collectionView.collectionViewLayout = layout
        collectionView.isSelectable = true
        collectionView.register(NSNib(nibNamed: "IZEpisodeItem", bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"))
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    var layout: NSCollectionViewFlowLayout {
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 60, height: 30)
        layout.sectionInset = NSEdgeInsetsMake(60, 20, 10, 20)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionHeadersPinToVisibleBounds = true
        return layout
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        let currentTime = player?.currentTime()
        if currentTime != nil {
            let currentTimeNum = currentTime!.value / Int64(currentTime!.timescale)
            do {
                let query = plot.filter(vid == id)
                try db.run(query.update(prate <- currentTimeNum))
            } catch {}
            player?.currentItem!.removeObserver(self, forKeyPath: "status", context: nil)
        }
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}

extension IZPlotMessageViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    func collectionView(_: NSCollectionView, numberOfItemsInSection _: Int) -> Int {
        if model?.code == 0 {
            return (model!.data.zu.first?.ji.count)!
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), for: indexPath) as! IZEpisodeItem
        let m = model!.data.zu.first?.ji[indexPath.item]
        item.setLevel(level: (m?.name)!)
        return item
    }

    func collectionView(_: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        idx = indexPaths.first!.item
        let m = model!.data.zu.first?.ji[idx]
        playVideo(url: m!.purl, levelName: m!.name, update: true)
    }
}
