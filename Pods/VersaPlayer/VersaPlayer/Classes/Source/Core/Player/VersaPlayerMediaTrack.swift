//
//  VersaPlayerMediaTrack.swift
//  VersaPlayer
//
//  Created by Jose Quintero on 10/30/18.
//

import AVFoundation
import Foundation

public struct VersaPlayerMediaTrack {
    public var option: AVMediaSelectionOption
    public var group: AVMediaSelectionGroup
    public var name: String
    public var language: String

    public func select(for player: VersaPlayer) {
        player.currentItem?.select(option, in: group)
    }
}
