//
//  Animation.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/20/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation
import SceneKit

class Animation {
    
    init() {
        
    }
    
    public static func spin(_ node: SCNNode, x: Float, y: Float, z: Float, d: Duration) {
        let action = SCNAction.rotateBy(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: d.rawValue)
        node.runAction(action)
    }
    
    public static func disappear(_ node: SCNNode, d: Duration) {
        let action = SCNAction.fadeOut(duration: d.rawValue)
        node.runAction(action)
    }
    
    public static func appear(_ node: SCNNode, d: Duration) {
        let action = SCNAction.fadeIn(duration: d.rawValue)
        node.runAction(action)
    }
    
    public static func move(_ node: SCNNode, x: Float, y: Float, z: Float, d: Duration) {
        let action = SCNAction.moveBy(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: d.rawValue)
        node.runAction(action)
    }
    
    public static func scale(_ node: SCNNode, to newSize: Float, d: Duration){
        let action = SCNAction.scale(to: CGFloat(newSize), duration: d.rawValue)
        node.runAction(action)
    }
    
    public static func infiniteRotate(_ node: SCNNode, x: Float, y: Float, z: Float, d: Duration) {
        let action = SCNAction.repeatForever(SCNAction.rotateBy(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: d.rawValue))
        node.runAction(action)
    }
    
    // Mark: - Particle Effects
    
    public static func explode(color: UIColor, geometry: SCNGeometry) -> SCNParticleSystem {
        let boom = SCNParticleSystem(named: "BulletParticle.scnp", inDirectory: nil)
        boom?.particleColor = color
        boom?.emitterShape = geometry
        return boom!
    }
    
    public static func emitLight(geometry: SCNGeometry) -> SCNParticleSystem {
        let light = SCNParticleSystem(named: "BlackHoleParticle", inDirectory: nil)
        light?.emitterShape = geometry
        return light!
    }
    
    public static func tail(geometry: SCNGeometry) -> SCNParticleSystem {
        let tail = SCNParticleSystem(named: "CometParticle", inDirectory: nil)
        tail?.emitterShape = geometry
        return tail!
    }
    
    public static func flare(geometry: SCNGeometry) -> SCNParticleSystem {
        let flare = SCNParticleSystem(named: "FireParticle", inDirectory: nil)
        flare?.emitterShape = geometry
        return flare!
    }
    
}
