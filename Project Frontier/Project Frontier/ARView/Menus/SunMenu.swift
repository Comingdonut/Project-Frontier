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
        for x in stride(from: 0, to: size, by: 1) {
            let node = ObjectNode(dimension)
            node.opacity = 0.0
            options.append(node)
            if x == 0 {
                initOption(x, "Yellow Sun", .sphere, "yellowsun")
            }
            else if x == 1 {
                initOption(x, "Red Sun", .sphere, "redsun")
            }
            else if x == 2 {
                initOption(x, "Blue Sun", .sphere, "bluesun")
            }
            else if x == 3 {
                initOption(x, "White Dwarf", .sphere, "whitedwarf")
            }
            else if x == 4 {
                initOption(x, "Black Dwarf", .sphere, .black)
            }
            else if x == 5 {
                initOption(x, "Back", .box, .orange)
            }
            else if x == 6 {
                options[x].setDimension(to: 0.030)
                initOption(x, "Choose a Subject", .text, .white)
            }
            else if x == 7 {
                initOption(x, "Yellow Sun", .text, .white)
            }
            else if x == 8 {
                initOption(x, "Red Sun", .text, .white)
            }
            else if x == 9 {
                initOption(x, "Blue Sun", .text, .white)
            }
            else if x == 10 {
                initOption(x, "White Dwarf", .text, .white)
            }
            else if x == 11 {
                initOption(x, "Black Dwarf", .text, .white)
            }
            else if x == 12 {
                initOption(x, "Back", .text, .white)
            }
        }
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
        let slow = 10.0
        let medium = 7.0
        let fast = 4.0
        let light = 1.0
        let anim: Animation = Animation()
        for sun in options {
            anim.appear(sun, d: 1.5)
        }
        anim.infiniteRotate(options[0], x: 0, y: 1, z: 0, d: medium)
        anim.infiniteRotate(options[1], x: 0, y: 1, z: 0, d: fast)
        anim.infiniteRotate(options[2], x: 0, y: 1, z: 0, d: slow)
        anim.infiniteRotate(options[3], x: 0, y: 1, z: 0, d: light)
    }
}
