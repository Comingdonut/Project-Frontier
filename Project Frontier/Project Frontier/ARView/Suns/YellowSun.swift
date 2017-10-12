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
        size = 10 // TODO: Include astroid belt
        objects = []
    }
    
    func initSubject() {
        
        for _ in stride(from: 0, to: size, by: 1) {
            let node = ObjectNode()
            node.opacity = 0.0
            objects.append(node)
        }
        
        initObject(0, "Medium Sun", 0.030, .sphere, .yellow)
        initObject(1, "Mercury", 0.015, .sphere, .lightgray)
        initObject(2, "Venus", 0.017, .sphere, .red)
        initObject(3, "Earth", 0.018, .sphere, .green)
        initObject(4, "Mars", 0.016, .sphere, .orange)
        // TODO: Asteroid Belt Here
        initObject(5, "Jupiter", 0.024, .sphere, 1, 0.79, 0.61, 1)
        initObject(6, "Saturn", 0.023, .sphere, 1, 0.93, 0.75, 1)
        initObject(7, "Uranus", 0.021, .sphere, .cyan)
        initObject(8, "Neptune", 0.020, .sphere, .blue)
        initObject(9, "Plane Info", 0.15, .plane, image: "DialogBoxMedium")
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
        let textYOffSet: Float = 0.40
        let textZOffSet: Float = 0.070
        var distance: Float = 0.030
        let offSet: Float = 0.20
        let none: Float = 0.0
        
        for obj in objects {
            obj.setPosition(x, y, z, none, offSet, distance*obj.multiplier)
            distance+=0.045
        }
        objects[9].setPosition(x, y, z, none, textYOffSet, textZOffSet)
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
