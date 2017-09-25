//
//  ARMenu.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/17/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation
import SceneKit

class ARMenu {
    
    let size: Int = 6
    let addition: Int = 2
    
    var categories: [ObjectNode]
    
    init() {
        categories = []
    }
    
    func initARMenu (_ dimension: Float) {
        for x in stride(from: 0, to: size*addition, by: 1) {
            let node = ObjectNode(dimension)
            node.opacity = 0.0
            categories.append(node)
            if x > 0 && x % 2 == 0 {
                initCategory(x, "Coming Soon", .box, .gray)
            }
            else if x > 1 &&  x % 2 == 1 {
                initCategory(x, "Coming Soon", .text, .white)
            }
            else if x == 0 {
                initCategory(x, "Sun", .sphere, .yellow)
            }
            else if x == 1 {
                initCategory(x, "Sun", .text, .white)
            }
        }
        
    }
    
    func initCategory(_ index: Int, _ name: String, _ geometry: Shape, _ color: Color) {
        categories[index].setName(to: name)
        categories[index].setShape(geometry)
        categories[index].setColor(color)
    }
    
    func setCategoryPositions(_ x: Float, _ y: Float, _ z: Float) {
        let offSet: Float = 0.15
        let textOffSet: Float = 0.08
        let none: Float = 0.0
        categories[0].setPosition(x, y, z, none, offSet, none)
        categories[1].setPosition(x, y, z, none, offSet, none+textOffSet)
        categories[2].setPosition(x, y, z, offSet, offSet, none)
        categories[3].setPosition(x, y, z, offSet, offSet, none+textOffSet)
        categories[4].setPosition(x, y, z, -offSet, offSet, none)
        categories[5].setPosition(x, y, z, -offSet, offSet, none+textOffSet)
        categories[6].setPosition(x, y, z, none, offSet, -offSet)
        categories[7].setPosition(x, y, z, none, offSet, -offSet+textOffSet)
        categories[8].setPosition(x, y, z, offSet, offSet, -offSet)
        categories[9].setPosition(x, y, z, offSet, offSet, -offSet+textOffSet)
        categories[10].setPosition(x, y, z, -offSet, offSet, -offSet)
        categories[11].setPosition(x, y, z, -offSet, offSet, -offSet+textOffSet)
    }
    
    func show() {
        let anim: Animation = Animation()
        for cat in categories {
            anim.appear(cat, duration: 1.5)
        }
    }
    
    func hide (except node: SCNNode) {
        let anim: Animation = Animation()
        for cat in categories{
            if cat.name != node.name {
                anim.disappear(cat, duration: 1.5)
            }
        }
    }
}
