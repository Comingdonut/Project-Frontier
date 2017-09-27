//
//  YellowSun.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/27/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation
import SceneKit

class YellowSun: Subject {
    
    var size: Int
    var objects: [ObjectNode]
    
    required init() {
        size = 9 // TODO: Include astroid belt
        objects = []
    }
    
    func initSubject() {
        
        for _ in stride(from: 0, to: size, by: 1) {
            let node = ObjectNode()
            objects.append(node)
        }
        
        initObject(0, "Sun", .sphere, .yellow)
        initObject(1, "Mercury", .sphere, .lightgray)
        initObject(2, "Venus", .sphere, .red)
        initObject(3, "Earth", .sphere, .green)
        initObject(4, "Mars", .sphere, .orange)
        // TODO: Asteroid Belt Here
        initObject(5, "Jupiter", .sphere, 255, 202, 156, 255)
        initObject(6, "Saturn", .sphere, 255, 237, 191, 255)
        initObject(7, "Uranus", .sphere, .cyan)
        initObject(8, "Neptune", .sphere, .blue)
    }
    
    func initObject(_ index: Int, _ name: String, _ geometry: Shape, _ color: Color) {
        objects[index].setName(to: name)
        objects[index].setShape(geometry)
        objects[index].setColor(color)
    }
    
    func initObject(_ index: Int, _ name: String, _ geometry: Shape, _ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        objects[index].setName(to: name)
        objects[index].setShape(geometry)
        objects[index].setColor(r: r, g: g, b: b, a: a)
    }
    
    func setObjectPositions(_ x: Float, _ y: Float, _ z: Float) {
        
    }
    
    func show() {
        
    }
    
    func hide() {
        
    }
    
}
