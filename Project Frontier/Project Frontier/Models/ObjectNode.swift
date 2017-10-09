//
//  ObjectNode.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/16/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation
import SceneKit

class ObjectNode: SCNNode {
    
    var dimension: Float // Size 0.025
    var multiplier: Float // Small = 1.0, Medium = 2.0, Large = 3.0
    var isBullet: Bool
	var hasText: Bool
    
    override init() {
        dimension = 0.025
        multiplier = 2.0
        isBullet = false
		hasText = false
        super.init()
    }
	
	init(_ dimension: Float) {
		self.dimension = dimension
		multiplier = 2.0
		isBullet = false
		hasText = false
		super.init()
	}
    
	init(_ dimension: Float, hasText: Bool) {
        self.dimension = dimension
        multiplier = 2.0
        isBullet = false
		self.hasText = hasText
        super.init()
    }
    
    init(_ dimension: Float, _ isBullet: Bool) {
        self.dimension = dimension
        multiplier = 2.0
        self.isBullet = isBullet
		hasText = false
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	func setDimension(to dimension: Float) {
		self.dimension = dimension
	}
	
	func setName(to name: String) {
		self.name = name
	}
    
    func setPosition(_ x: Float, _ y: Float, _ z: Float, _ xOffSet: Float, _ yOffSet: Float, _ zOffSet: Float) {
        self.position = SCNVector3Make(x + xOffSet, y + yOffSet, z + zOffSet)
		if hasText {
			let textOffSet: Float = 0.06
			let text = ObjectNode(dimension)
			text.setName(to: name!)
			text.setShape(.text)
			text.setColor(.white)
			text.setPosition(0, 0, 0, 0, 0, 0 + textOffSet)
			self.addChildNode(text)
		}
		else if (self.geometry as? SCNText) != nil {
			let (min, max) = boundingBox
			let dx = min.x + 0.5 * (max.x - min.x)
			let dy = min.y + 0.5 * (max.y - min.y)
			let dz = min.z + 0.5 * (max.z - min.z)
			pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
		}
    }
    
    func setColor(_ color: Color) {
        let material = self.geometry?.firstMaterial
		switch(color){ // Missing colors: brown, clear
		case .magenta:
			material?.diffuse.contents = UIColor.magenta
			break
        case .red:
            material?.diffuse.contents = UIColor.red
            break
        case .orange:
            material?.diffuse.contents = UIColor.orange
            break
        case .yellow:
            material?.diffuse.contents = UIColor.yellow
            break
        case .green:
            material?.diffuse.contents = UIColor.green
            break
		case .cyan:
			material?.diffuse.contents = UIColor.cyan
			break
        case .blue:
            material?.diffuse.contents = UIColor.blue
            break
        case .purple:
            material?.diffuse.contents = UIColor.purple
            break
        case .white:
            material?.diffuse.contents = UIColor.white
            break
		case .lightgray:
			material?.diffuse.contents = UIColor.lightGray
			break
        case .gray:
            material?.diffuse.contents = UIColor.gray
            break
		case .darkgray:
			material?.diffuse.contents = UIColor.darkGray
			break
        case .black:
			material?.diffuse.contents = UIColor.black
            break
        }
    }
	
	func setColor(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
		let material = self.geometry?.firstMaterial
		material?.diffuse.contents = UIColor.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
	}
	
	func setTexture(to prefix: String) {
		let material = self.geometry?.firstMaterial
		material?.diffuse.contents = UIImage(named: "\(prefix)-albedo.png")
		material?.roughness.contents = UIImage(named: "\(prefix)-roughness.png")
		material?.metalness.contents = 0
		material?.normal.contents = UIImage(named: "\(prefix)-normal.png")
	}
    
    func setShape(_ shape: Shape) {
        switch(shape){
        case .box:
            let box = newBox(dimension)
            self.geometry = box
            setPhysicsBody(Box: box)
            break
        case .sphere:
            let sphere = newSphere(dimension)
            self.geometry = sphere
            setPhysicsBody(Sphere: sphere)
            break
		case .ring:
			let ring = newRing(dimension)
			self.geometry = ring
			setPhysicsBody(Ring: ring)
			break
		case .pill:
			let pill = newPill(dimension)
			self.geometry = pill
			setPhysicsBody(Pill: pill)
			break
		case .text:
			let text = newText(dimension)
			self.geometry = text
			break
        }
    }
    
    func setPhysicsBody(Box box: SCNBox) {
        let shape = SCNPhysicsShape(geometry: box, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false;
        
        self.physicsBody?.categoryBitMask = CollisionCategory.object.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.bullet.rawValue
    }
    
    func setPhysicsBody(Sphere sphere: SCNSphere) {
        let shape = SCNPhysicsShape(geometry: sphere, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false;
        if isBullet {
            self.physicsBody?.categoryBitMask = CollisionCategory.bullet.rawValue
            self.physicsBody?.contactTestBitMask = CollisionCategory.object.rawValue
        }
        else {
            self.physicsBody?.categoryBitMask = CollisionCategory.object.rawValue
            self.physicsBody?.contactTestBitMask = CollisionCategory.bullet.rawValue
        }
    }
	
	func setPhysicsBody(Ring ring: SCNTorus) {
		let shape = SCNPhysicsShape(geometry: ring, options: nil)
		self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
		self.physicsBody?.isAffectedByGravity = false;
		
		self.physicsBody?.categoryBitMask = CollisionCategory.object.rawValue
		self.physicsBody?.contactTestBitMask = CollisionCategory.bullet.rawValue
	}
	
	func setPhysicsBody(Pill pill: SCNCapsule) {
		let shape = SCNPhysicsShape(geometry: pill, options: nil)
		self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
		self.physicsBody?.isAffectedByGravity = false;
		
		self.physicsBody?.categoryBitMask = CollisionCategory.object.rawValue
		self.physicsBody?.contactTestBitMask = CollisionCategory.bullet.rawValue
	}
    
    func newBox(_ dimension: Float) -> SCNBox {
        let box = SCNBox(width: CGFloat(dimension * multiplier),
                     height: CGFloat(dimension * multiplier) ,
                     length: CGFloat(dimension * multiplier),
                     chamferRadius: CGFloat(0.0))
        return box
    }
	
	func newSphere(_ dimension: Float) -> SCNSphere {
		let sphere = SCNSphere(radius: CGFloat(dimension * multiplier))
		return sphere
	}
	
	func newRing(_ dimension: Float) -> SCNTorus {
		let ring = SCNTorus(
			ringRadius: CGFloat(dimension),
			pipeRadius: CGFloat(dimension/2))
		return ring
	}
	
	func newPill(_ dimension: Float) -> SCNCapsule {
		let pill = SCNCapsule(capRadius: CGFloat(dimension/3), height: CGFloat(dimension))
		return pill
	}
	
	func newText(_ dimension: Float) -> SCNText {
		let text = SCNText(string: self.name, extrusionDepth: CGFloat(dimension))
		self.scale = SCNVector3(dimension, dimension, dimension)
		text.font = UIFont.init(name: "Helvetica", size: 1)
		return text
	}
}
