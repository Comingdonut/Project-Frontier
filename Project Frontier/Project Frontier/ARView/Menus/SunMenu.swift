//
//  SunMenu.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/27/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation
import SceneKit

class SunMenu: Menu {
    
    var size: Int
    
    var options: [ObjectNode]
    
    required init() {
        size = 13
        options = []
    }
    
    func initMenu(_ dimension: Float) {
        for _ in stride(from: 0, to: size, by: 1) {
            let node = ObjectNode(dimension)
            node.opacity = 0.0
            options.append(node)
        }
        initOption(0, "Yellow Sun", .sphere, "yellowsun")
        initOption(1, "Red Sun", .sphere, "redsun")
        initOption(2, "Blue Sun", .sphere, "bluesun")
        initOption(3, "White Dwarf", .sphere, "whitedwarf")
        initOption(4, "Black Dwarf", .sphere, .black)
        initOption(5, "Back", .box, .orange)
        options[6].setDimension(to: 0.030)
        initOption(6, "Choose a Subject", .text, .white)
        initOption(7, "Yellow Sun", .text, .white)
        initOption(8, "Red Sun", .text, .white)
        initOption(9, "Blue Sun", .text, .white)
        initOption(10, "White Dwarf", .text, .white)
        initOption(11, "Black Dwarf", .text, .white)
        initOption(12, "Back", .text, .white)
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
        let none: Float = 0.0
        options[0].setPosition(x, y, z, none, offSet, none)
        options[1].setPosition(x, y, z, offSet, offSet, none)
        options[2].setPosition(x, y, z, -offSet, offSet, none)
        options[3].setPosition(x, y, z, none, offSet, -offSet)
        options[4].setPosition(x, y, z, offSet, offSet, -offSet)
        options[5].setPosition(x, y, z, -offSet, offSet, -offSet)
        options[6].setPosition(x, y, z, none, textYOffSet, none)
        options[7].setPosition(x, y, z, none, offSet, none+textZOffSet)
        options[8].setPosition(x, y, z, offSet, offSet, none+textZOffSet)
        options[9].setPosition(x, y, z, -offSet, offSet, none+textZOffSet)
        options[10].setPosition(x, y, z, none, offSet, -offSet+textZOffSet)
        options[11].setPosition(x, y, z, offSet, offSet, -offSet+textZOffSet)
        options[12].setPosition(x, y, z, -offSet, offSet, -offSet+textZOffSet)
    }
    
    func show() {
        let anim: Animation = Animation()
        for sun in options {
            anim.appear(sun, d: Duration.light)
        }
        anim.infiniteRotate(options[0], x: 0, y: 1, z: 0, d: Duration.medium)
        anim.infiniteRotate(options[1], x: 0, y: 1, z: 0, d: Duration.fast)
        anim.infiniteRotate(options[2], x: 0, y: 1, z: 0, d: Duration.slow)
        anim.infiniteRotate(options[3], x: 0, y: 1, z: 0, d: Duration.light)
    }
}
