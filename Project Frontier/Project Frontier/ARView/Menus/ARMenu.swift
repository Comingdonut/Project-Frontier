//
//  ARMenu.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/17/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation
import SceneKit

class ARMenu: Menu {
    
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
        initOption(0, "Star", .sphere, "yellowstar")
        initOption(1, "Black Hole", .sphere, .gray)
        initOption(2, "Solar Sytem", .ring, .gray)
        initOption(3, "TBA", .box, .gray)
        initOption(4, "TBA", .box, .gray)
        initOption(5, "TBA", .box, .gray)
        options[6].setDimension(to: 0.030)
        initOption(6, "Choose a Category", .text, .white)
        initOption(7, "Star", .text, .white)
        initOption(8, "Black Hole", .text, .white)
        initOption(9, "Solar System", .text, .white)
        initOption(10, "TBA", .text, .white)
        initOption(11, "TBA", .text, .white)
        initOption(12, "TBA", .text, .white)
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
        let none: Float = 0.0
        let y_axis: Float = 1.0
        for opt in options {
            Animation.appear(opt, d: Duration.light)
        }
        for j in stride(from: 0, to: 6, by: 1){
            Animation.infiniteRotate(options[j], x: none, y: y_axis, z: none, d: Duration.medium)
        }
    }
}
