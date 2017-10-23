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
    
    static func spin(_ node: SCNNode, x: Float, y: Float, z: Float, d: Duration) {
        let action = SCNAction.rotateBy(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: d.rawValue)
        node.runAction(action)
    }
    
    static func disappear(_ node: SCNNode, d: Duration) {
        let action = SCNAction.fadeOut(duration: d.rawValue)
        node.runAction(action)
    }
    
    static func appear(_ node: SCNNode, d: Duration) {
        let action = SCNAction.fadeIn(duration: d.rawValue)
        node.runAction(action)
    }
    
    static func move(_ node: SCNNode, x: Float, y: Float, z: Float, d: Duration) {
        let action = SCNAction.moveBy(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: d.rawValue)
        node.runAction(action)
    }
    
    static func scale(_ node: SCNNode, to newSize: Float, d: Duration){
        let action = SCNAction.scale(to: CGFloat(newSize), duration: d.rawValue)
        node.runAction(action)
    }
    
    static func infiniteRotate(_ node: SCNNode, x: Float, y: Float, z: Float, d: Duration) {
        let action = SCNAction.repeatForever(SCNAction.rotateBy(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: d.rawValue))
        node.runAction(action)
    }
    
    // Mark: - Particle Effects
    
    static func explode(color: UIColor, geometry: SCNGeometry) -> SCNParticleSystem {
        let boom = SCNParticleSystem(named: "BulletParticle.scnp", inDirectory: nil)
        boom?.particleColor = color
        boom?.emitterShape = geometry
        return boom!
    }
    
    // Mark: - Timer
    
    static func wait(inSeconds duration: Duration, repeating repeats: Bool, codeBlock: @escaping (Timer) -> Void) {
        _ = Timer.scheduledTimer(withTimeInterval: duration.rawValue, repeats: repeats, block: codeBlock)
    }
    
}
