//
//  AudioPlayer.swift
//  Project Frontier
//
//  Created by James Castrejon on 10/20/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer {
    
    static var player: AVAudioPlayer = AVAudioPlayer()
    
    init() {
        
    }
    
    static func pickSong(_ fileName: String, _ fileType: String) {
        do {
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: fileType)!))
            player.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    
    static func play() {
        player.play()
    }
    
    static func reset() {
        player.stop()
        player.currentTime = 0
    }
}
