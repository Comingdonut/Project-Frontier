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
    @IBOutlet weak var backButton: UIButton!
    
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let index = defaults.integer(forKey: DefaultsKeys.key1_theme)
        themeControl.selectedSegmentIndex = index
        if index == 1 {
            background.image = UIImage(named: "DimBackgroundLight")
            backButton.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
        }
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
            break
        case 1:
            defaults.set(1, forKey: DefaultsKeys.key1_theme)
            background.image = UIImage(named: "DimBackgroundLight")
            backButton.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
            break
        default:
            print("Error")
        }
    }
    
}
