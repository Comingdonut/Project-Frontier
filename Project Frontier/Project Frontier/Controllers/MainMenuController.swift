//
//  MainMenuController.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/3/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import UIKit

class MainMenuController: UIViewController{
    
    @IBOutlet weak var mainMenuBackground: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let theme = defaults.integer(forKey: KeysData.key1_theme)
        if theme == 1 {
            mainMenuBackground.image = UIImage(named: "BackgroundLight")
            startButton.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
            settingsButton.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
            helpButton.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
            aboutButton.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
        }
        
        let statusOn = defaults.bool(forKey: KeysData.key2_statusbar)
        if !statusOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light_speed.rawValue, execute: {//Wait
                UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelStatusBar
            })
        }
        
        let musicOn = defaults.bool(forKey: KeysData.key5_music)
        if musicOn {
            AudioPlayer.pickSong("Future Discoveries", "mp3")
            AudioPlayer.playMusic()
            AudioPlayer.loopMusic()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
