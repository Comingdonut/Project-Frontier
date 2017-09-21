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
    
    func spin(_ node: SCNNode, x: Float, y: Float, z: Float, d: TimeInterval) {
        let action = SCNAction.rotateBy(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: d)
        node.runAction(action)
    }
    
    func disappear(_ node: SCNNode, duration: TimeInterval) {
        let action = SCNAction.fadeOut(duration: duration)
        node.runAction(action)
    }
    
    func appear(_ node: SCNNode, duration: TimeInterval) {
        let action = SCNAction.fadeIn(duration: duration)
        node.runAction(action)
    }
    
    func move(_ node: SCNNode, duration: TimeInterval) {
        // TODO: Replace bottom code
        let action = SCNAction.move(by: SCNVector3(x: 0, y: 0, z: 0), duration: 0)
        node.runAction(action)
    }
    
    // Mark: - Particle Effects
    
    func createTrails(color: UIColor, geometry: SCNGeometry) -> SCNParticleSystem {
        let trail = SCNParticleSystem(named: "BulletParticle.scnp", inDirectory: nil)
        trail?.particleColor = color
        trail?.emitterShape = geometry
        trail?.particleLifeSpan = 0.1
        return trail!
    }
    
}
