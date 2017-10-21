//
//  YellowSun.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/27/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation
import SceneKit

class YellowStar: Subject {
    
    var size: Int
    var objects: [ObjectNode]
    
    required init() {
        size = 11 // TODO: Include astroid belt
        objects = []
    }
    
    func initSubject() {
        
        for _ in stride(from: 0, to: size, by: 1) {
            let node = ObjectNode()
            node.opacity = 0.0
            objects.append(node)
        }
        
        objects[0].useNameForText = false
        objects[0].customText = "Shoot Me!"
        initObject(objects, 0, "Info Text" ,0.001, .text, .white)
        initObject(objects, 1, "Info Panel", 0.030, .plane, image: "DialogBoxMedium")
        initObject(objects, 2, "Medium Star", 0.030, .sphere, texture: "yellowstar")
        initObject(objects, 3, "Mercury Helper", 0.010, .sphere, .clear)
        initObject(objects, 4, "Venus Helper", 0.010, .sphere, .clear)
        initObject(objects, 5, "Earth Helper", 0.010, .sphere, .clear)
        initObject(objects, 6, "Mars Helper", 0.010, .sphere, .clear)
        initObject(objects, 7, "Juptier Helper", 0.010, .sphere, .clear)
        initObject(objects, 8, "Saturn Helper", 0.010, .sphere, .clear)
        initObject(objects, 9, "Uranus Helper", 0.010, .sphere, .clear)
        initObject(objects, 10, "Neptune Helper", 0.010, .sphere, .clear)
        addChildrenNodes()
    }
    
    func initObject(_ objects: [ObjectNode], _ index: Int, _ name: String, _ size: Float, _ geometry: Shape, _ color: Color) {
        objects[index].setName(to: name)
        objects[index].setDimension(to: size)
        objects[index].setShape(geometry)
        objects[index].setColor(color)
    }
    
    func initObject(_ objects: [ObjectNode], _ index: Int, _ name: String, _ size: Float, _ geometry: Shape, _ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        objects[index].setName(to: name)
        objects[index].setDimension(to: size)
        objects[index].setShape(geometry)
        objects[index].setColor(r, g, b, a)
    }
    
    func initObject(_ objects: [ObjectNode], _ index: Int, _ name: String, _ size: Float, _ geometry: Shape, texture: String) {
        objects[index].setName(to: name)
        objects[index].setDimension(to: size)
        objects[index].setShape(geometry)
        objects[index].setTexture(to: texture)
    }
    
    func initObject(_ objects: [ObjectNode], _ index: Int, _ name: String, _ size: Float, _ geometry: Shape, image: String) {
        objects[index].setName(to: name)
        objects[index].setDimension(to: size)
        objects[index].setShape(geometry)
        objects[index].setImage(to: image)
    }
    
    func addChildrenNodes() {
        let planetNames: [String] =     ["Mercury", "Venus", "Earth",
                                         "Mars", "Jupiter", "Saturn",
                                         "Uranus", "Neptune"]
        let planetTextures: [String] =  ["mercury", "venus", "earth",
                                         "mars", "jupiter", "saturn",
                                         "uranus", "neptune"]
        let planetSize: [Float] =       [  0.010,   0.013,   0.014,
                                           0.012,   0.024,   0.021,
                                           0.019,   0.018]
        var planets: [ObjectNode] = []
        
        for _ in stride(from: 2, to: size, by: 1) {
            let node = ObjectNode()
            planets.append(node)
        }
        
        var distance: Float = 0.078
        let none: Float = 0.0
        for j in stride(from: 3, to: size, by: 1) {
            initObject(planets, j-3, planetNames[j-3], planetSize[j-3], .sphere, texture: planetTextures[j-3])
            planets[j-3].setPosition(none, none, none, none, none, distance*planets[j-3].multiplier)
            objects[j].addChildNode(planets[j-3])
            distance+=0.048
        }
    }
    
    func setObjectPositions(_ x: Float, _ y: Float, _ z: Float) {
        let distance: Float = 0.030
        let offSet: Float = 0.20
        let none: Float = 0.0
        
        for j in stride(from: 2, to: size, by: 1) {
            objects[j].setPosition(x, y, z, none, offSet, distance*objects[j].multiplier)
        }
        objects[0].setPosition(x, y, z, none, 0.43, 0.062)
        objects[1].setPosition(x, y, z, none, 0.40, 0.060)
    }
    
    func show() {
        let anim: Animation = Animation()
        for obj in objects {
            anim.appear(obj, d: Duration.light)
        }
    }
    
    func animate() {
        let anim: Animation = Animation()
        
        for x in stride(from: 0, to: 9, by: 1){
            if x == 0 {//Instructions
                anim.scaleUp(objects[0], to: 0.030, d: Duration.light)
                anim.scaleUp(objects[1], to: 3.0, d: Duration.light)
            }
            else if x == 1 {//Planet Orbits
                anim.infiniteRotate(objects[2], x: 0, y: 1, z: 0, d: Duration.medium)
                anim.infiniteRotate(objects[3], x: 0, y: 1, z: 0, d: Duration.light)
            }
            else if x == 2 {
                anim.infiniteRotate(objects[4], x: 0, y: 1, z: 0, d: Duration.fast_fast)
                anim.infiniteRotate(objects[5], x: 0, y: 1, z: 0, d: Duration.fast)
            }
            else if x == 3 {
                anim.infiniteRotate(objects[6], x: 0, y: 1, z: 0, d: Duration.fast_slow)
                anim.infiniteRotate(objects[7], x: 0, y: 1, z: 0, d: Duration.medium)
            }
            else if x == 4 {
                anim.infiniteRotate(objects[8], x: 0, y: 1, z: 0, d: Duration.medium_slow)
                anim.infiniteRotate(objects[9], x: 0, y: 1, z: 0, d: Duration.slow_fast)
                anim.infiniteRotate(objects[10], x: 0, y: 1, z: 0, d: Duration.slow)
            }
            else if x == 5 {//Planets Rotation
                anim.infiniteRotate((objects[3].childNodes.first)!, x: 0, y: 1, z: 0, d: Duration.fast_fast)
                anim.infiniteRotate((objects[4].childNodes.first)!, x: 0, y: -1, z: 0, d: Duration.light)
            }
            else if x == 6 {
                anim.infiniteRotate((objects[5].childNodes.first)!, x: 0, y: 1, z: 0, d: Duration.medium)
                anim.infiniteRotate((objects[6].childNodes.first)!, x: 0, y: 1, z: 0, d: Duration.medium_fast)
            }
            else if x == 7 {
                anim.infiniteRotate((objects[7].childNodes.first)!, x: 0, y: 1, z: 0, d: Duration.slow)
                anim.infiniteRotate((objects[8].childNodes.first)!, x: 0, y: 1, z: 0, d: Duration.slow_fast)
            }
            else if x == 8 {
                anim.infiniteRotate((objects[9].childNodes.first)!, x: 0, y: 0, z: -1, d: Duration.medium_slow)
                anim.spin((objects[9].childNodes.first)!, x: 1.55, y: 0, z: 0, d: Duration.light)
                anim.infiniteRotate((objects[10].childNodes.first)!, x: 0, y: 1, z: 0, d: Duration.medium_slow)
            }
        }
    }
}
