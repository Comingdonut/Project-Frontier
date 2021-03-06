//
//  WhiteStar.swift
//  Project Frontier
//
//  Created by James Castrejon on 10/31/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation
import SceneKit

class WhiteStar: Subject {
    
    private let defaults = UserDefaults.standard
    
    var size: Int
    var objects: [ObjectNode]
    var color: Color
    
    required init() {
        size = 3 // TODO: Include astroid belt
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
        initObject(objects, 1, "White Dwarf Star", 0.030, .sphere, texture: "whitedwarf")
        initObject(objects, 2, "Planet Helper", 0.010, .sphere, .clear)
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
        let node = ObjectNode()
        node.setName(to: "Planet")
        node.setDimension(to: 0.010)
        node.setShape(.sphere)
        node.setTexture(to: "planet")
        
        let distance: Float = 0.078
        let none: Float = 0.0
        node.setPosition(none, none, none, none, none, distance*node.multiplier)
        
        objects[2].addChildNode(node)
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
    
    func animate() {
        Animation.scale(objects[0], to: 0.030, d: Duration.light)
        Animation.infiniteRotate(objects[1], x: 0, y: 1, z: 0, d: Duration.light)
        Animation.infiniteRotate(objects[2], x: 0, y: -1, z: 0, d: Duration.fast_fast)
        Animation.infiniteRotate((objects[2].childNodes.first)!, x: 0, y: -1, z: 0, d: Duration.fast_slow)
    }
}
