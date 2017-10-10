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
    
    func disappear(_ node: SCNNode, d: TimeInterval) {
        let action = SCNAction.fadeOut(duration: d)
        node.runAction(action)
    }
    
    func appear(_ node: SCNNode, d: TimeInterval) {
        let action = SCNAction.fadeIn(duration: d)
        node.runAction(action)
    }
    
    func move(_ node: SCNNode, x: Float, y: Float, z: Float, d: TimeInterval) {
        let action = SCNAction.moveBy(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: d)
        node.runAction(action)
    }
    
    func rotate(_ node: SCNNode) {
        let action = SCNAction.rotateBy(x: 0.0, y: 1.0, z: 0.0, duration: 1.0)
        node.runAction(action)
    }
    
    func infiniteRotate(_ node: SCNNode, x: Float, y: Float, z: Float, d: TimeInterval) {
        let action = SCNAction.repeatForever(SCNAction.rotateBy(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: d))
        node.runAction(action)
    }
    
    func rotate(_ node: SCNNode, d: TimeInterval) {
        var xAxis: Float = node.position.x
        var zAxis: Float = node.position.z
        let transform: Float = 0.001
        repeat {
//            print("X-Axis: \(xAxis)")
//            print("Z-Axis: \(zAxis)")
            if (xAxis <= 0.000 && xAxis >= -0.029) && (zAxis <= 0.030 && zAxis >= 0.001) {
                xAxis-=transform
                zAxis-=transform
            }
            else if (xAxis >= -0.030 && xAxis <= -0.001) && (zAxis <= 0.000 && zAxis >= -0.029) {
                xAxis+=transform
                zAxis-=transform
            }
            else if (xAxis >= 0.000 && xAxis <= 0.029) && (zAxis >= -0.030 && zAxis <= -0.001) {
                xAxis+=transform
                zAxis+=transform
            }
            else if (xAxis <= 0.030 && xAxis >= 0.001) && (zAxis >= 0.000 && zAxis <= 0.029) {
                xAxis-=transform
                zAxis+=transform
            }
            else {
                break
            }
            xAxis = Float(round(xAxis*1000)/1000)
            zAxis = Float(round(zAxis*1000)/1000)
            let action = SCNAction.moveBy(x: CGFloat(xAxis), y: CGFloat(node.position.y), z: CGFloat(zAxis), duration: d)
            node.runAction(action)
        } while true
    }
    
    // Mark: - Particle Effects
    
    func explode(color: UIColor, geometry: SCNGeometry) -> SCNParticleSystem {
        let boom = SCNParticleSystem(named: "BulletParticle.scnp", inDirectory: nil)
        boom?.particleColor = color
        boom?.emitterShape = geometry
        return boom!
    }
    
}
