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
    
    var categories: [ObjectNode]
    
    init() {
        categories = []
    }
    
    func initARMenu (_ dimension: Float) {
        for x in stride(from: 0, to: 6, by: 1) {
            let node = ObjectNode(dimension)
            if x > 0 {
                node.setName(to: "Coming Soon")
                node.setShape(.box)
                node.setColor(.gray)
            }
            categories.append(node)
        }
        
    }
    
    func initCategory(_ geometry: Shape, _ color: Color) {
        categories[0].setName(to: "Sun")
        categories[0].setShape(geometry)
        categories[0].setColor(.yellow)
    }
    
    func setCategoryPositions(_ x: Float, _ y: Float, _ z: Float) {
        let offSet: Float = 0.15
        let none: Float = 0.0
        categories[0].setPosition(x, y, z, none, offSet, none)
        categories[1].setPosition(x, y, z, offSet, offSet, none)
        categories[2].setPosition(x, y, z, -offSet, offSet, none)
        categories[3].setPosition(x, y, z, none, offSet, -offSet)
        categories[4].setPosition(x, y, z, offSet, offSet, -offSet)
        categories[5].setPosition(x, y, z, -offSet, offSet, -offSet)
    }
    
}
