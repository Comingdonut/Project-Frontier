//
//  ARMenu.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/17/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation
import SceneKit

class ARMenu: Menu {
    
    private let defaults = UserDefaults.standard
    
    var size: Int
    var options: [ObjectNode]
    var color: Color
    
    required init() {
        size = 13
        options = []
        color = Color.white
        
        let index = defaults.integer(forKey: KeysData.key4_textColor)
        if index == 1 {
            color = Color.black
        }
    }
    
    func initMenu(_ dimension: Float) {
        for _ in stride(from: 0, to: size, by: 1) {
            let node = ObjectNode(dimension)
            node.opacity = 0.0
            options.append(node)
        }
        initOption(0, "Star", .sphere, "yellowstar")
        options[0].addParticleSystem(Animation.flare(geometry: options[0].geometry!))
        initOption(1, "Black Hole", .sphere, .black)
        options[1].addParticleSystem(Animation.emitLight(geometry: options[1].geometry!))
        options[2].setDimension(to: 0.009)
        initOption(2, "Solar Sytem", .sphere, "yellowstar")
        options[3].setDimension(to: 0.012)
        initOption(3, "Comet", .sphere, "comet")
        options[3].addParticleSystem(Animation.tail(geometry: options[3].geometry!))
        options[4].setDimension(to: 0.019)
        initOption(4, "Exoplanet", .sphere, "exoplanet2")
        options[5].setDimension(to: 0.015)
        initOption(5, "Dwarf Planets", .sphere, "pluto")
        options[6].setDimension(to: 0.030)
        initOption(6, NSLocalizedString(KeysLocalize.DefaultKey1_Category, comment: ""), .text, color)
        initOption(7, NSLocalizedString(KeysLocalize.MenuKey1_Star, comment: ""), .text, color)
        initOption(8, NSLocalizedString(KeysLocalize.MenuKey3_BlackHole, comment: ""), .text, color)
        initOption(9, NSLocalizedString(KeysLocalize.MenuKey2_SolarSystem, comment: ""), .text, color)
        initOption(10, NSLocalizedString(KeysLocalize.MenuKey4_Comet, comment: ""), .text, color)
        initOption(11, NSLocalizedString(KeysLocalize.MenuKey5_Exoplanet, comment: ""), .text, color)
        initOption(12, NSLocalizedString(KeysLocalize.MenuKey6_DwarfPlanet, comment: ""), .text, color)
        createSolarSystem(options[2])
    }
    
    func initOption(_ index: Int, _ name: String, _ geometry: Shape, _ color: Color) {
        options[index].setName(to: name)
        options[index].setShape(geometry)
        options[index].setColor(color)
    }
    
    func initOption(_ index: Int, _ name: String, _ geometry: Shape, _ texture: String) {
        options[index].setName(to: name)
        options[index].setShape(geometry)
        options[index].setTexture(to: texture)
    }
    
    func setOptionPositions(_ x: Float, _ y: Float, _ z: Float) {
        let textYOffSet: Float = 0.40
        let textZOffSet: Float = 0.06
        let offSet: Float = 0.15
        let none: Float = 0.0
        options[0].setPosition(x, y, z, none, offSet, none)
        options[1].setPosition(x, y, z, offSet, offSet, none)
        options[2].setPosition(x, y, z, -offSet, offSet, none)
        options[3].setPosition(x, y, z, none, offSet, -offSet)
        options[4].setPosition(x, y, z, offSet, offSet, -offSet)
        options[5].setPosition(x, y, z, -offSet, offSet, -offSet)
        options[6].setPosition(x, y, z, none, textYOffSet, none)
        options[7].setPosition(x, y, z, none, offSet, none+textZOffSet)
        options[8].setPosition(x, y, z, offSet, offSet, none+textZOffSet)
        options[9].setPosition(x, y, z, -offSet, offSet, none+textZOffSet)
        options[10].setPosition(x, y, z, none, offSet, -offSet+textZOffSet)
        options[11].setPosition(x, y, z, offSet, offSet, -offSet+textZOffSet)
        options[12].setPosition(x, y, z, -offSet, offSet, -offSet+textZOffSet)
    }
    
    func show() {
        let none: Float = 0.0
        let y_axis: Float = 1.0
        for opt in options {
            Animation.appear(opt, d: Duration.light)
        }
        for j in stride(from: 0, to: 6, by: 1){
            if j != 1 && j != 3 {
                Animation.infiniteRotate(options[j], x: none, y: y_axis, z: none, d: Duration.medium)
            }
        }
        Animation.infiniteRotate(options[5], x: none, y: y_axis, z: none, d: Duration.light_slow)
    }
    
    public func rotatePlanets() {
        for x in stride(from: 0, to: 8, by: 1) {
            if x == 0 {//Planet Orbits
                Animation.infiniteRotate(options[2].childNodes[0], x: 0, y: 1, z: 0, d: Duration.light)
                Animation.infiniteRotate(options[2].childNodes[1], x: 0, y: -1, z: 0, d: Duration.fast_fast)
            }
            else if x == 1 {
                Animation.infiniteRotate(options[2].childNodes[2], x: 0, y: 1, z: 0, d: Duration.fast)
                Animation.infiniteRotate(options[2].childNodes[3], x: 0, y: 1, z: 0, d: Duration.fast_slow)
            }
            else if x == 2 {
                Animation.infiniteRotate(options[2].childNodes[4], x: 0, y: 1, z: 0, d: Duration.medium)
                Animation.infiniteRotate(options[2].childNodes[5], x: 0, y: 1, z: 0, d: Duration.medium_slow)
            }
            else if x == 3 {
                Animation.infiniteRotate(options[2].childNodes[6], x: 0, y: -3, z: 0, d: Duration.slow_fast)
                Animation.infiniteRotate(options[2].childNodes[7], x: 0, y: 1, z: 0, d: Duration.slow)
            }
            else if x == 4 {//Planets Rotation
                Animation.infiniteRotate(options[2].childNodes[0].childNodes.first!, x: 0, y: 1, z: 0, d: Duration.fast_fast)
                Animation.infiniteRotate(options[2].childNodes[1].childNodes.first!, x: 0, y: -1, z: 0, d: Duration.light)
            }
            else if x == 5 {
                Animation.infiniteRotate(options[2].childNodes[2].childNodes.first!, x: 0, y: 1, z: 0, d: Duration.medium)
                Animation.infiniteRotate(options[2].childNodes[3].childNodes.first!, x: 0, y: 1, z: 0, d: Duration.medium_fast)
            }
            else if x == 6 {
                Animation.infiniteRotate(options[2].childNodes[4].childNodes.first!, x: 0, y: 1, z: 0, d: Duration.slow)
                Animation.infiniteRotate(options[2].childNodes[5].childNodes.first!, x: 0, y: 1, z: 0, d: Duration.slow_fast)
            }
            else if x == 7 {
                Animation.infiniteRotate(options[2].childNodes[6].childNodes.first!, x: 0, y: -1, z: 0, d: Duration.medium_slow)
                Animation.spin(options[2].childNodes[6].childNodes.first!, x: 0, y: 0, z: 1.55, d: Duration.light)
                Animation.infiniteRotate(options[2].childNodes[7].childNodes.first!, x: 0, y: 1, z: 0, d: Duration.medium_slow)
            }
        }
    }
    
    private func createSolarSystem(_ parent: ObjectNode) {
        let planetCount = 8
        var solarSystem: [ObjectNode] = []
        let helperNames: [String] = ["Mercury Helper",
                                   "Venus Helper",
                                   "Earth Helper",
                                   "Mars Helper",
                                   "Jupiter Helper",
                                   "Saturn Helper",
                                   "Uranus Helper",
                                   "Neptune Helper"]
        let helperSize: [Float] = [0.001,
                                     0.0050,
                                     0.0050,
                                     0.0050,
                                     0.0050,
                                     0.0050,
                                     0.0050,
                                     0.0050]
        
        for x in stride(from: 0, to: planetCount, by: 1) {
            let node: ObjectNode = ObjectNode()
            node.setName(to: helperNames[x])
            node.setDimension(to: helperSize[x])
            node.setShape(.sphere)
            node.setColor(.clear)
            node.setPosition(0, 0, 0, 0, 0, 0)
            solarSystem.append(node)
            parent.addChildNode(node)
        }
        
        addPlanetNodes(solarSystem)
        
    }
    
    private func addPlanetNodes(_ parents: [ObjectNode]) {
        let planetNames: [String] =     ["Solar Sytem", "Solar Sytem", "Solar Sytem",
                                         "Solar Sytem", "Solar Sytem", "Solar Sytem",
                                         "Solar Sytem", "Solar Sytem"]
        let planetTextures: [String] =  ["mercury", "venus", "earth",
                                         "mars", "jupiter", "saturn",
                                         "uranus", "neptune"]
        let planetSize: [Float] =       [  0.0010,   0.0013,   0.0014,
                                           0.0012,   0.0024,   0.0021,
                                           0.0019,   0.0018]
        var planets: [ObjectNode] = []
        
        var distance: Float = 0.0063
        let none: Float = 0.0
        
        for k in stride(from: 0, to: planetNames.count, by: 1) {
            let node = ObjectNode()
            node.setName(to: planetNames[k])
            node.setDimension(to: planetSize[k])
            node.setShape(.sphere)
            node.setTexture(to: planetTextures[k])
            distance+=0.0048
            planets.append(node)
            planets[k].setPosition(none, none, none, none, none, distance*planets[k].multiplier)
            parents[k].addChildNode(node)
        }
        
        addSaturnRings(saturn: planets[5])
    }
    
    private func addSaturnRings(saturn: ObjectNode) {
        let rings: ObjectNode = ObjectNode()
        rings.setName(to: "Saturn's Rings")
        let ring = SCNTorus(
            ringRadius: CGFloat(0.0055),
            pipeRadius: CGFloat(0.0008))
        rings.geometry = ring
        rings.setColor(1, 0.94, 0.78, 0.75)
        rings.setPosition(0, 0, 0, 0, 0, 0)
        saturn.addChildNode(rings)
    }
}
