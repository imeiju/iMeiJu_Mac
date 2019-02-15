//
//  VPlayerLayer.swift
//  VersaPlayer Demo
//
//  Created by Jose Quintero on 10/11/18.
//  Copyright © 2018 Quasar. All rights reserved.
//

import AVFoundation
import AVKit

open class VersaPlayerLayer: CALayer {
    /// Player Layer to be used
    public var playerLayer: AVPlayerLayer!

    /// VersaPlayer instance being rendered
    public weak var handler: VersaPlayerView!

    deinit {
        #if DEBUG
            print("7 \(String(describing: self))")
        #endif
    }

    public override init(layer: Any) {
        super.init(layer: layer)
    }

    public override init() {
        super.init()
    }

    public convenience init(with player: VersaPlayerView) {
        self.init()
        playerLayer = AVPlayerLayer(player: player.player)
        addSublayer(playerLayer)
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSublayers() {
        super.layoutSublayers()
        playerLayer.frame = bounds
    }
}
