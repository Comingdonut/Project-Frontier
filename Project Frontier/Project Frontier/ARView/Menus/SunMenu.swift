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
        size = 6
        options = []
    }
    
    func initMenu(_ dimension: Float) {
        for x in stride(from: 0, to: size, by: 1) {
            let node = ObjectNode(dimension, hasText: true)
            node.opacity = 0.0
            options.append(node)
            if x == 0 {
                initOption(x, "Red Sun", .sphere, .red)
            }
            else if x == 1 {
                initOption(x, "Yellow Sun", .sphere, .yellow)
            }
            else if x == 2 {
                initOption(x, "Blue Sun", .sphere, .blue)
            }
            else if x == 3 {
                initOption(x, "White Dwarf", .sphere, .white)
            }
            else if x == 4 {
                initOption(x, "Black Dwarf", .sphere, .black)
            }
            else {
                initOption(x, "Back", .box, .orange)
            }
        }
    }
    
    func initOption(_ index: Int, _ name: String, _ geometry: Shape, _ color: Color) {
        options[index].setName(to: name)
        options[index].setShape(geometry)
        options[index].setColor(color)
    }
    
    func setOptionPositions(_ x: Float, _ y: Float, _ z: Float) {
        let offSet: Float = 0.15
        let none: Float = 0.0
        options[0].setPosition(x, y, z, none, offSet, none)
        options[1].setPosition(x, y, z, offSet, offSet, none)
        options[2].setPosition(x, y, z, -offSet, offSet, none)
        options[3].setPosition(x, y, z, none, offSet, -offSet)
        options[4].setPosition(x, y, z, offSet, offSet, -offSet)
        options[5].setPosition(x, y, z, -offSet, offSet, -offSet)
    }
    
    func show() {
        let anim: Animation = Animation()
        for sun in options {
            anim.appear(sun, d: 1.5)
        }
    }
}
