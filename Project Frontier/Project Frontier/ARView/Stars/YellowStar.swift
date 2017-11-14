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
    
    private let defaults = UserDefaults.standard
    
    var size: Int
    var objects: [ObjectNode]
    var color: Color
    
    required init() {
        size = 10 // TODO: Include astroid belt
        objects = []
        color = Color.white
        
        let index = defaults.integer(forKey: KeysData.key4_textColor)
        if index == 1 {
             color = Color.black
        }
    }
    
    func initSubject() {
        
        for _ in stride(from: 0, to: size, by: 1) {
            let node = ObjectNode()
            node.opacity = 0.0
            objects.append(node)
        }
        
        objects[0].useNameForText = false
        objects[0].customText = NSLocalizedString(KeysLocalize.DefaultKey5_Shoot, comment: "")
        initObject(objects, 0, "Info Text" ,0.001, .text, color)
        initObject(objects, 1, "Medium Star", 0.030, .sphere, texture: "yellowstar")
        initObject(objects, 2, "Mercury Helper", 0.010, .sphere, .clear)
        initObject(objects, 3, "Venus Helper", 0.010, .sphere, .clear)
        initObject(objects, 4, "Earth Helper", 0.010, .sphere, .clear)
        initObject(objects, 5, "Mars Helper", 0.010, .sphere, .clear)
        initObject(objects, 6, "Juptier Helper", 0.010, .sphere, .clear)
        initObject(objects, 7, "Saturn Helper", 0.010, .sphere, .clear)
        initObject(objects, 8, "Uranus Helper", 0.010, .sphere, .clear)
        initObject(objects, 9, "Neptune Helper", 0.010, .sphere, .clear)
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
    
    private func addChildrenNodes() {
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
        
        for _ in stride(from: 1, to: size, by: 1) {
            let node = ObjectNode()
            planets.append(node)
        }
        
        addSaturnRings(saturn: planets[5])
        
        var distance: Float = 0.078
        let none: Float = 0.0
        for j in stride(from: 2, to: size, by: 1) {
            initObject(planets, j-2, planetNames[j-2], planetSize[j-2], .sphere, texture: planetTextures[j-2])
            planets[j-2].setPosition(none, none, none, none, none, distance*planets[j-2].multiplier)
            objects[j].addChildNode(planets[j-2])
            distance+=0.048
        }
    }
    
    private func addSaturnRings(saturn: ObjectNode) {
        let rings: ObjectNode = ObjectNode()
        rings.setName(to: "Saturn's Rings")
        let ring = SCNTorus(
            ringRadius: CGFloat(0.055),
            pipeRadius: CGFloat(0.008))
        rings.geometry = ring
        rings.setColor(1, 0.94, 0.78, 1)
        rings.setPosition(0, 0, 0, 0, 0, 0)
        saturn.addChildNode(rings)
    }
    
    func setObjectPositions(_ x: Float, _ y: Float, _ z: Float) {
        let distance: Float = 0.030
        let offSet: Float = 0.20
        let none: Float = 0.0
        
        for j in stride(from: 1, to: size, by: 1) {
            objects[j].setPosition(x, y, z, none, offSet, distance*objects[j].multiplier)
        }
        objects[0].setPosition(x, y, z, none, 0.43, 0.062)
    }
    
    func show() {
        for obj in objects {
            Animation.appear(obj, d: Duration.light)
        }
    }
    
    public func animate() {
        for x in stride(from: 0, to: 9, by: 1) {
            if x == 0 {//Instructions
                Animation.scale(objects[0], to: 0.030, d: Duration.light)
                Animation.infiniteRotate(objects[1], x: 0, y: 1, z: 0, d: Duration.medium)
            }
            else if x == 1 {//Planet Orbits
                Animation.infiniteRotate(objects[2], x: 0, y: 1, z: 0, d: Duration.light)
                Animation.infiniteRotate(objects[3], x: 0, y: 1, z: 0, d: Duration.fast_fast)
            }
            else if x == 2 {
                Animation.infiniteRotate(objects[4], x: 0, y: 1, z: 0, d: Duration.fast)
                Animation.infiniteRotate(objects[5], x: 0, y: 1, z: 0, d: Duration.fast_slow)
            }
            else if x == 3 {
                Animation.infiniteRotate(objects[6], x: 0, y: 1, z: 0, d: Duration.medium)
                Animation.infiniteRotate(objects[7], x: 0, y: 1, z: 0, d: Duration.medium_slow)
            }
            else if x == 4 {
                Animation.infiniteRotate(objects[8], x: 0, y: 1, z: 0, d: Duration.slow_fast)
                Animation.infiniteRotate(objects[9], x: 0, y: 1, z: 0, d: Duration.slow)
            }
            else if x == 5 {//Planets Rotation
                Animation.infiniteRotate((objects[2].childNodes.first)!, x: 0, y: 1, z: 0, d: Duration.fast_fast)
                Animation.infiniteRotate((objects[3].childNodes.first)!, x: 0, y: -1, z: 0, d: Duration.light)
            }
            else if x == 6 {
                Animation.infiniteRotate((objects[4].childNodes.first)!, x: 0, y: 1, z: 0, d: Duration.medium)
                Animation.infiniteRotate((objects[5].childNodes.first)!, x: 0, y: 1, z: 0, d: Duration.medium_fast)
            }
            else if x == 7 {
                Animation.infiniteRotate((objects[6].childNodes.first)!, x: 0, y: 1, z: 0, d: Duration.slow)
                Animation.infiniteRotate((objects[7].childNodes.first)!, x: 0, y: 1, z: 0, d: Duration.slow_fast)
            }
            else if x == 8 {
                Animation.infiniteRotate((objects[8].childNodes.first)!, x: 0, y: 0, z: -1, d: Duration.medium_slow)
                Animation.spin((objects[8].childNodes.first)!, x: 1.55, y: 0, z: 0, d: Duration.light)
                Animation.infiniteRotate((objects[9].childNodes.first)!, x: 0, y: 1, z: 0, d: Duration.medium_slow)
            }
        }
    }
}
