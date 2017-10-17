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
        initObject(1, "Mercury", 0.010, .sphere, texture: "mercury")
        initObject(2, "Venus", 0.013, .sphere, texture: "venus")
        initObject(3, "Earth", 0.014, .sphere, texture: "earth")
        initObject(4, "Mars", 0.012, .sphere, texture: "mars")
        // TODO: Asteroid Belt Here
        initObject(5, "Jupiter", 0.024, .sphere, texture: "jupiter")
        initObject(6, "Saturn", 0.021, .sphere, texture: "saturn")
        initObject(7, "Uranus", 0.019, .sphere, texture: "uranus")
        initObject(8, "Neptune", 0.018, .sphere, texture: "neptune")
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
            distance+=0.048
        }
    }
    
    func show() {
        let anim: Animation = Animation()
        for obj in objects {
            anim.appear(obj, d: Duration.light)
        }
    }
    
    func rotate() {
//        anim.spin(objects[0], x: 0, y: 1, z: 0, d: Duration.medium)
//        anim.spin(objects[1], x: 0, y: 1, z: 0, d: Duration.light)
//        anim.spin(objects[2], x: 0, y: 1, z: 0, d: Duration.fast_fast)
//        anim.spin(objects[3], x: 0, y: 1, z: 0, d: Duration.fast)
//        anim.spin(objects[4], x: 0, y: 1, z: 0, d: Duration.fast_slow)
//        anim.spin(objects[5], x: 0, y: 1, z: 0, d: Duration.medium)
//        anim.spin(objects[6], x: 0, y: 1, z: 0, d: Duration.medium_slow)
//        anim.spin(objects[7], x: 0, y: 1, z: 0, d: Duration.slow_fast)
//        anim.spin(objects[8], x: 0, y: 1, z: 0, d: Duration.slow)
        let anim: Animation = Animation()
        for x in stride(from: 0, to: 4, by: 1){
            if x == 0 {
                anim.infiniteRotate(objects[0], x: 0, y: 1, z: 0, d: Duration.medium)
                anim.infiniteRotate(objects[1], x: 0, y: 1, z: 0, d: Duration.fast_fast)
            }
            else if x == 1 {
                anim.infiniteRotate(objects[2], x: 0, y: -1, z: 0, d: Duration.light)
                anim.infiniteRotate(objects[3], x: 0, y: 1, z: 0, d: Duration.medium)
            }
            else if x == 2 {
                anim.infiniteRotate(objects[4], x: 0, y: 1, z: 0, d: Duration.medium_fast)
                anim.infiniteRotate(objects[5], x: 0, y: 1, z: 0, d: Duration.slow)
                anim.infiniteRotate(objects[6], x: 0, y: 1, z: 0, d: Duration.slow_fast)
            }
            else if x == 3 {
                anim.infiniteRotate(objects[7], x: 0, y: 0, z: -1, d: Duration.medium_slow)
                anim.spin(objects[7], x: 1.55, y: 0, z: 0, d: Duration.light)
                anim.infiniteRotate(objects[8], x: 0, y: 1, z: 0, d: Duration.medium_slow)
            }
        }
    }
}
