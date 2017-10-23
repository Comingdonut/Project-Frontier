//
//  MainMenuController.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/3/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import UIKit

class MainMenuController: UIViewController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
        AudioPlayer.pickSong("Future Discoveries", "mp3")
        AudioPlayer.play()
        AudioPlayer.loop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

