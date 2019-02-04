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
    
    var vid: String!
    var model: IZPlotMessageModel!
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network()
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
                if self.model.code == 0 {
                    let v = self.model.data.zu.first!.ji.first!
                    let item = AVPlayerItem(url: URL(string: v.purl)!)
                    self.player = AVPlayer(playerItem: item)
                    self.player?.play()
                    self.playerView.player = self.player
                    let window = NSApplication.shared.windows.last!
                    window.title =  window.title + " " + v.name
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
