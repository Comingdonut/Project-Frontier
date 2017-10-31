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
    
    private static var music: AVAudioPlayer = AVAudioPlayer()
    private static var sound: AVAudioPlayer = AVAudioPlayer()
    private static var filePath: String = ""
    
    init() {
        
    }
    
    public static func pickSong(_ fileName: String, _ fileType: String) {
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
    
    public static func playMusic() {
        music.play()
    }
    
    public static func resetMusic() {
        music.pause()
        music.currentTime = 0
    }
    
    public static func loopMusic() {
        music.numberOfLoops = -1
    }
    
    public static func stopMusic() {
        music.stop()
    }
    
    public static func pickSound(_ fileName: String, _ fileType: String) {
        do {
            sound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: fileType)!))
            sound.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    
    public static func playSound() {
        sound.play()
    }
}
