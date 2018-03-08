//
//  BlackHole.swift
//  Project Frontier
//
//  Created by James Castrejon on 3/6/18.
//  Copyright © 2018 James Castrejon. All rights reserved.
//

import Foundation
import SceneKit

class BlackHole {
    
    private let defaults = UserDefaults.standard
    
    var blackHole: ObjectNode
    var textFacts: ObjectNode
    var color: Color
    
    init() {
        
        color = Color.white
        
        let index = defaults.integer(forKey: KeysData.key4_textColor)
        if index == 1 {
            color = Color.black
        }
        blackHole = ObjectNode()
        textFacts = ObjectNode()
        self.initBlackHole()
        self.blackHoleFacts()
    }
    
    private func initBlackHole() {
        blackHole.setName(to: "BlackHole")
        blackHole.setShape(Shape.sphere)
        blackHole.setColor(Color.black)
        blackHole.setDimension(to: 0.030)
    }
    
    private func blackHoleFacts() {
        textFacts.setName(to: "Info Text")
        textFacts.useNameForText = false
        textFacts.customText = NSLocalizedString("This is a Black Hole.", comment: "")
        textFacts.setShape(.text)
        textFacts.setColor(color)
        textFacts.setDimension(to: 0.001)
    }
    
    public func setPositions(_ x: Float, _ y: Float, _ z: Float) {
        let textYOffSet: Float = 0.40
        let textZOffSet: Float = 0.06
        let offSet: Float = 0.15
        blackHole.setPosition(x, y, z, 0, offSet, 0)
        textFacts.setPosition(x, y, z, 0, textYOffSet, textZOffSet)
    }
    
    public func animate(){
        blackHole.addParticleSystem(Animation.emitLight(geometry: blackHole.geometry!))
        Animation.scale(textFacts, to: 0.030, d: Duration.light)
    }
    
}
