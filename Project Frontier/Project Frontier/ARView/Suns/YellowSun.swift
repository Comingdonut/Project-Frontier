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
            node.opacity = 0.0
            objects.append(node)
        }
        
        initObject(0, "Medium Sun", 0.030, .sphere, texture: "yellowsun")
        initObject(1, "Mercury", 0.015, .sphere, texture: "mercury")
        initObject(2, "Venus", 0.017, .sphere, texture: "venus")
        initObject(3, "Earth", 0.018, .sphere, texture: "earth")
        initObject(4, "Mars", 0.016, .sphere, texture: "mars")
        // TODO: Asteroid Belt Here
        initObject(5, "Jupiter", 0.024, .sphere, texture: "jupiter")
        initObject(6, "Saturn", 0.023, .sphere, texture: "saturn")
        initObject(7, "Uranus", 0.021, .sphere, texture: "uranus")
        initObject(8, "Neptune", 0.020, .sphere, texture: "neptune")
    }
    
    func initObject(_ index: Int, _ name: String, _ size: Float, _ geometry: Shape, _ color: Color) {
        objects[index].setName(to: name)
        objects[index].setDimension(to: size)
        objects[index].setShape(geometry)
        objects[index].setColor(color)
    }
    
    func initObject(_ index: Int, _ name: String, _ size: Float, _ geometry: Shape, _ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        objects[index].setName(to: name)
        objects[index].setDimension(to: size)
        objects[index].setShape(geometry)
        objects[index].setColor(r, g, b, a)
    }
    
    func initObject(_ index: Int, _ name: String, _ size: Float, _ geometry: Shape, texture: String) {
        objects[index].setName(to: name)
        objects[index].setDimension(to: size)
        objects[index].setShape(geometry)
        objects[index].setTexture(to: texture)
    }
    
    func initObject(_ index: Int, _ name: String, _ size: Float, _ geometry: Shape, image: String) {
        objects[index].setName(to: name)
        objects[index].setDimension(to: size)
        objects[index].setShape(geometry)
        objects[index].setImage(to: image)
    }
    
    func setObjectPositions(_ x: Float, _ y: Float, _ z: Float) {
        var distance: Float = 0.030
        let offSet: Float = 0.20
        let none: Float = 0.0
        
        for obj in objects {
            obj.setPosition(x, y, z, none, offSet, distance*obj.multiplier)
            distance+=0.045
        }
    }
    
    func show() {
        let anim: Animation = Animation()
        for obj in objects {
            anim.appear(obj, d: Duration.light)
        }
    }
    
    func rotate() {
        let anim: Animation = Animation()
        for obj in objects {
            anim.infiniteRotate(obj,x: 0.0, y: 1.0, z: 0.0, d: Duration.medium)
        }
    }
}
