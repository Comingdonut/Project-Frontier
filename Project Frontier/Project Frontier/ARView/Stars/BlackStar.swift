//
//  BlackStar.swift
//  Project Frontier
//
//  Created by James Castrejon on 11/6/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation
import SceneKit

class BlackStar: Subject {
    
    private let defaults = UserDefaults.standard
    
    var size: Int
    var objects: [ObjectNode]
    
    required init() {
        size = 2
        objects = []
    }
    
    func initSubject() {
        
        for _ in stride(from: 0, to: size, by: 1) {
            let node = ObjectNode()
            node.opacity = 0.0
            objects.append(node)
        }
        
        objects[0].useNameForText = false
        objects[0].customText = NSLocalizedString(KeysLocalize.DefaultKey5_Shoot, comment: "")
        initObject(objects, 0, "Info Text", 0.001, .text, .white)
        initObject(objects, 1, "Black Dwarf Star", 0.030, .sphere, .black)
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
    }
    
}
