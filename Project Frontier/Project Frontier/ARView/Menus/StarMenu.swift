//
//  SunMenu.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/27/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation
import SceneKit

class StarMenu: Menu {
    
    private let defaults = UserDefaults.standard
    
    var size: Int
    var options: [ObjectNode]
    var color: Color
    
    required init() {
        size = 15
        options = []
        color = Color.white
        
        let index = defaults.integer(forKey: KeysData.key4_textColor)
        if index == 1 {
            color = Color.black
        }
    }
    
    func initMenu(_ dimension: Float) {
        for _ in stride(from: 0, to: size, by: 1) {
            let node = ObjectNode(dimension)
            node.opacity = 0.0
            options.append(node)
        }
        initOption(0, "Yellow Star", .sphere, "yellowstar")
        initOption(1, "Red Star", .sphere, "redstar")
        initOption(2, "Blue Star", .sphere, "bluestar")
        initOption(3, "White Dwarf", .sphere, "whitedwarf")
        initOption(4, "Black Dwarf", .sphere, .black)
        initOption(5, "Brown Dwarf", .sphere, "browndwarf")
        options[6].setDimension(to: dimension*options[6].multiplier)
        initOption(6, "Back", .pyramid, .orange)
        options[7].setDimension(to: 0.030)
        initOption(7, NSLocalizedString(KeysLocalize.DefaultKey2_Subject, comment: ""), .text, color)
        initOption(8, NSLocalizedString(KeysLocalize.StarKey1_Yellow, comment: ""), .text, color)
        initOption(9, NSLocalizedString(KeysLocalize.StarKey3_Red, comment: ""), .text, color)
        initOption(10, NSLocalizedString(KeysLocalize.StarKey2_Blue, comment: ""), .text, color)
        initOption(11, NSLocalizedString(KeysLocalize.StarKey4_White, comment: ""), .text, color)
        initOption(12, NSLocalizedString(KeysLocalize.StarKey5_Black, comment: ""), .text, color)
        initOption(13, NSLocalizedString(KeysLocalize.StarKey6_Brown, comment: ""), .text, color)
        initOption(14, NSLocalizedString(KeysLocalize.DefaultKey4_Back, comment: ""), .text, color)
    }
    
    func initOption(_ index: Int, _ name: String, _ geometry: Shape, _ color: Color) {
        options[index].setName(to: name)
        options[index].setShape(geometry)
        options[index].setColor(color)
    }
    
    func initOption(_ index: Int, _ name: String, _ geometry: Shape, _ texture: String) {
        options[index].setName(to: name)
        options[index].setShape(geometry)
        options[index].setTexture(to: texture)
    }
    
    func setOptionPositions(_ x: Float, _ y: Float, _ z: Float) {
        let textYOffSet: Float = 0.40
        let textZOffSet: Float = 0.06
        let offSet: Float = 0.15
        let offBSet: Float = 0.23
        let offB2Set: Float = 0.08
        let none: Float = 0.0
        options[0].setPosition(x, y, z, none, offSet, none) //Front
        options[1].setPosition(x, y, z, offSet, offSet, none)
        options[2].setPosition(x, y, z, -offSet, offSet, none)
        options[3].setPosition(x, y, z, -offB2Set, offSet, -offSet)//Back
        options[4].setPosition(x, y, z, offB2Set, offSet, -offSet)
        options[5].setPosition(x, y, z, offBSet, offSet, -offSet)
        options[6].setPosition(x, y, z, -offBSet, offSet, -offSet)
        options[7].setPosition(x, y, z, none, textYOffSet, none)//Text
        options[8].setPosition(x, y, z, none, offSet, none+textZOffSet)//Front Text
        options[9].setPosition(x, y, z, offSet, offSet, none+textZOffSet)
        options[10].setPosition(x, y, z, -offSet, offSet, none+textZOffSet)
        options[11].setPosition(x, y, z, -offB2Set, offSet, -offSet+textZOffSet)//Back Text
        options[12].setPosition(x, y, z, offB2Set, offSet, -offSet+textZOffSet)
        options[13].setPosition(x, y, z, offBSet, offSet, -offSet+textZOffSet)
        options[14].setPosition(x, y, z, -offBSet, offSet, -offSet+textZOffSet)
    }
    
    func show() {
        for star in options {
            Animation.appear(star, d: Duration.light)
        }
        Animation.infiniteRotate(options[0], x: 0, y: 1, z: 0, d: Duration.medium)
        Animation.infiniteRotate(options[1], x: 0, y: 1, z: 0, d: Duration.fast)
        Animation.infiniteRotate(options[2], x: 0, y: 1, z: 0, d: Duration.slow)
        Animation.infiniteRotate(options[3], x: 0, y: 1, z: 0, d: Duration.light)
        Animation.infiniteRotate(options[5], x: 0, y: 1, z: 0, d: Duration.medium_fast)
        Animation.spin(options[6], x: 0, y: 0, z: 1.55, d: Duration.light)
    }
}

