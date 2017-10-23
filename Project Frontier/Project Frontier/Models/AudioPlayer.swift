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
    static var filePath: String = ""
    
    init() {
        
    }
    
    static func pickSong(_ fileName: String, _ fileType: String) {
        do {
            if fileName != filePath {
                player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: fileType)!))
                player.prepareToPlay()
                filePath = fileName
            }
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
    
    static func loop() {
        player.numberOfLoops = -1
    }
}
