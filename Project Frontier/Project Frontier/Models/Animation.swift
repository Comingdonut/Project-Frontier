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
    
    func spin(_ node: SCNNode, x: Float, y: Float, z: Float, d: Duration) {
        let action = SCNAction.rotateBy(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: d.rawValue)
        node.runAction(action)
    }
    
    func disappear(_ node: SCNNode, d: Duration) {
        let action = SCNAction.fadeOut(duration: d.rawValue)
        node.runAction(action)
    }
    
    func appear(_ node: SCNNode, d: Duration) {
        let action = SCNAction.fadeIn(duration: d.rawValue)
        node.runAction(action)
    }
    
    func move(_ node: SCNNode, x: Float, y: Float, z: Float, d: Duration) {
        let action = SCNAction.moveBy(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: d.rawValue)
        node.runAction(action)
    }
    
    func infiniteRotate(_ node: SCNNode, x: Float, y: Float, z: Float, d: Duration) {
        let action = SCNAction.repeatForever(SCNAction.rotateBy(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: d.rawValue))
        node.runAction(action)
    }
    
    // Mark: - Particle Effects
    
    func explode(color: UIColor, geometry: SCNGeometry) -> SCNParticleSystem {
        let boom = SCNParticleSystem(named: "BulletParticle.scnp", inDirectory: nil)
        boom?.particleColor = color
        boom?.emitterShape = geometry
        return boom!
    }
    
}
