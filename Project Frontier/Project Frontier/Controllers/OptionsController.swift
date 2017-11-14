//
//  OptionsController.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/3/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import UIKit

class OptionsController: UIViewController{
    
    private let defaults = UserDefaults.standard
    
    @IBOutlet weak var themeControl: UISegmentedControl!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var switchStatus: UISwitch!
    @IBOutlet weak var switchTutorial: UISwitch!
    @IBOutlet weak var textColorControl: UISegmentedControl!
    @IBOutlet weak var switchMusic: UISwitch!
    @IBOutlet weak var switchSound: UISwitch!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let index = defaults.integer(forKey: KeysData.key1_theme)
        let index2 = defaults.integer(forKey: KeysData.key4_textColor)
        themeControl.selectedSegmentIndex = index
        textColorControl.selectedSegmentIndex = index2
        if index == 1 {
            background.image = UIImage(named: "DimBackgroundLight")
            switchStatus.onTintColor = UIColor(red: Theme.l_r, green: Theme.l_g, blue: Theme.l_b, alpha: Theme.a)
            switchTutorial.onTintColor = UIColor(red: Theme.l_r, green: Theme.l_g, blue: Theme.l_b, alpha: Theme.a)
            switchMusic.onTintColor = UIColor(red: Theme.l_r, green: Theme.l_g, blue: Theme.l_b, alpha: Theme.a)
            switchSound.onTintColor = UIColor(red: Theme.l_r, green: Theme.l_g, blue: Theme.l_b, alpha: Theme.a)
            backButton.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
        }
        
        let sbOn = defaults.bool(forKey: KeysData.key2_statusbar)
        let tOn = defaults.bool(forKey: KeysData.key3_tutorial)
        let mOn = defaults.bool(forKey: KeysData.key5_music)
        let sOn = defaults.bool(forKey: KeysData.key6_sound)
        switchStatus.isOn = sbOn
        switchTutorial.isOn = tOn
        switchMusic.isOn = mOn
        switchSound.isOn = sOn
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func themeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            defaults.set(0, forKey: KeysData.key1_theme)
            background.image = UIImage(named: "DimBackground")
            switchStatus.onTintColor = UIColor(red: Theme.d_r, green: Theme.d_g, blue: Theme.d_b, alpha: Theme.a)
            switchTutorial.onTintColor = UIColor(red: Theme.d_r, green: Theme.d_g, blue: Theme.d_b, alpha: Theme.a)
            switchMusic.onTintColor = UIColor(red: Theme.d_r, green: Theme.d_g, blue: Theme.d_b, alpha: Theme.a)
            switchSound.onTintColor = UIColor(red: Theme.d_r, green: Theme.d_g, blue: Theme.d_b, alpha: Theme.a)
            backButton.setBackgroundImage(UIImage(named: "ButtonBackground"), for: UIControlState.normal)
            break
        case 1:
            defaults.set(1, forKey: KeysData.key1_theme)
            background.image = UIImage(named: "DimBackgroundLight")
            switchStatus.onTintColor = UIColor(red: Theme.l_r, green: Theme.l_g, blue: Theme.l_b, alpha: Theme.a)
            switchTutorial.onTintColor = UIColor(red: Theme.l_r, green: Theme.l_g, blue: Theme.l_b, alpha: Theme.a)
            switchMusic.onTintColor = UIColor(red: Theme.l_r, green: Theme.l_g, blue: Theme.l_b, alpha: Theme.a)
            switchSound.onTintColor = UIColor(red: Theme.l_r, green: Theme.l_g, blue: Theme.l_b, alpha: Theme.a)
            backButton.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
            break
        default:
            print("Error")
        }
    }
    
    @IBAction func statusSwitch(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: KeysData.key2_statusbar)
        if sender.isOn {
            UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
        } else {
            UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelStatusBar
        }
    }
    
    @IBAction func tutorialSwitch(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: KeysData.key3_tutorial)
    }

    @IBAction func textColorChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            defaults.set(0, forKey: KeysData.key4_textColor)
            break
        case 1:
            defaults.set(1, forKey: KeysData.key4_textColor)
            break
        default:
            print("Error")
            break
        }
    }
    
    @IBAction func musicSwitch(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: KeysData.key5_music)
        if sender.isOn {
            AudioPlayer.pickSong("Future Discoveries", "mp3")
            AudioPlayer.playMusic()
            AudioPlayer.loopMusic()
        }
        else {
            AudioPlayer.stopMusic()
        }
    }
    
    @IBAction func soundSwitch(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: KeysData.key6_sound)
    }
}
