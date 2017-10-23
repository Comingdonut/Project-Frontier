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
    
    static var music: AVAudioPlayer = AVAudioPlayer()
    static var sound: AVAudioPlayer = AVAudioPlayer()
    static var filePath: String = ""
    
    init() {
        
    }
    
    static func pickSong(_ fileName: String, _ fileType: String) {
        do {
            if fileName != filePath {
                music = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: fileType)!))
                music.prepareToPlay()
                filePath = fileName
            }
        }
        catch {
            print(error)
        }
    }
    
    static func playMusic() {
        music.play()
    }
    
    static func resetMusic() {
        music.stop()
        music.currentTime = 0
    }
    
    static func loopMusic() {
        music.numberOfLoops = -1
    }
    
    static func pickSound(_ fileName: String, _ fileType: String) {
        do {
            sound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: fileType)!))
            sound.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    
    static func playSound() {
        sound.play()
    }
}
