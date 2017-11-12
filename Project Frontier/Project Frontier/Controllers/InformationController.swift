//
//  InformationController.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/4/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import UIKit

class InformationController: UIViewController{
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var buttonBack: UIButton!
    
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let index = defaults.integer(forKey: KeysData.key1_theme)
        if index == 1 {
            background.image = UIImage(named: "DimBackgroundLight")
            buttonBack.setBackgroundImage(UIImage(named: "ButtonBackgroundLight"), for: UIControlState.normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
