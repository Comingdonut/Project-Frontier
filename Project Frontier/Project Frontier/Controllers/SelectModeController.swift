//
//  SelectModeController.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/4/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import UIKit

class SelectModeController: UIViewController{
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var buttonSmall: UIButton!
    @IBOutlet weak var buttonMedium: UIButton!
    @IBOutlet weak var buttonLarge: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let index = defaults.integer(forKey: KeysData.key1_theme)
        
        if index == 1 {
            background.image = UIImage(named: "BackgroundLight")
            buttonSmall.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
            buttonMedium.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
            buttonLarge.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
            backButton.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
            infoButton.setBackgroundImage(UIImage(named: "SmallButtonBackgroundLight"), for: UIControlState.normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
