//
//  OptionsController.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/3/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import UIKit

class OptionsController: UIViewController{
    
    @IBOutlet weak var themeControl: UISegmentedControl!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var switchMusic: UISwitch!
    @IBOutlet weak var switchSound: UISwitch!
    @IBOutlet weak var backButton: UIButton!
    
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let index = defaults.integer(forKey: DefaultsKeys.key1_theme)
        themeControl.selectedSegmentIndex = index
        if index == 1 {
            background.image = UIImage(named: "DimBackgroundLight")
            backButton.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
            switchMusic.onTintColor = UIColor(red: Theme.l_r, green: Theme.l_g, blue: Theme.l_b, alpha: Theme.a)
            switchSound.onTintColor = UIColor(red: Theme.l_r, green: Theme.l_g, blue: Theme.l_b, alpha: Theme.a)
        }
        let mOn = defaults.bool(forKey: DefaultsKeys.key2_music)
        let sOn = defaults.bool(forKey: DefaultsKeys.key3_sound)
        if !mOn {
            switchMusic.isOn = mOn
        }
        if !sOn {
            switchSound.isOn = sOn
        }
        print("Before: \(switchMusic.isOn)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func themeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            defaults.set(0, forKey: DefaultsKeys.key1_theme)
            background.image = UIImage(named: "DimBackground")
            backButton.setBackgroundImage(UIImage(named: "ButtonBackground"), for: UIControlState.normal)
            switchMusic.onTintColor = UIColor(red: Theme.d_r, green: Theme.d_g, blue: Theme.d_b, alpha: Theme.a)
            switchSound.onTintColor = UIColor(red: Theme.d_r, green: Theme.d_g, blue: Theme.d_b, alpha: Theme.a)
            break
        case 1:
            defaults.set(1, forKey: DefaultsKeys.key1_theme)
            background.image = UIImage(named: "DimBackgroundLight")
            backButton.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
            switchMusic.onTintColor = UIColor(red: Theme.l_r, green: Theme.l_g, blue: Theme.l_b, alpha: Theme.a)
            switchSound.onTintColor = UIColor(red: Theme.l_r, green: Theme.l_g, blue: Theme.l_b, alpha: Theme.a)
            break
        default:
            print("Error")
        }
    }
    
    @IBAction func musicSwitch(_ sender: UISwitch) {
        if sender.isOn {
            AudioPlayer.pickSong("Future Discoveries", "mp3")
            AudioPlayer.playMusic()
            AudioPlayer.loopMusic()
            defaults.set(true, forKey: DefaultsKeys.key2_music)
        }
        else {
            AudioPlayer.stopMusic()
            defaults.set(false, forKey: DefaultsKeys.key2_music)
        }
        print("After: \(switchMusic.isOn)")
    }
    
    @IBAction func soundSwitch(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: DefaultsKeys.key3_sound)
    }
    
}
