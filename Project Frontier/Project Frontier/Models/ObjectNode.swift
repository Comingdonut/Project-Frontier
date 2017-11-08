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
    
    private var dimension: Float // Size 0.025
    public var multiplier: Float // Small = 1.0, Medium = 2.0, Large = 3.0
    private var isBullet: Bool
	public var useNameForText: Bool
	public var customText: String
    
    override init() {
        dimension = 0.025
        multiplier = 2.0
        isBullet = false
		useNameForText = true
		customText = ""
        super.init()
    }
	
	init(_ dimension: Float) {
		self.dimension = dimension
		multiplier = 2.0
		isBullet = false
		useNameForText = true
		customText = ""
		super.init()
	}
    
    init(_ dimension: Float, _ isBullet: Bool) {
        self.dimension = dimension
        multiplier = 2.0
        self.isBullet = isBullet
		useNameForText = true
		customText = ""
        super.init()
    }
	
	init(_ dimension: Float, _ useName: Bool, _ customText: String) {
		self.dimension = dimension
		multiplier = 2.0
		isBullet = false
		useNameForText = useName
		self.customText = customText
		super.init()
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	public func setDimension(to dimension: Float) {
		self.dimension = dimension
	}
	
	public func setName(to name: String) {
		self.name = name
	}
    
    public func setPosition(_ x: Float, _ y: Float, _ z: Float, _ xOffSet: Float, _ yOffSet: Float, _ zOffSet: Float) {
        self.position = SCNVector3Make(x + xOffSet, y + yOffSet, z + zOffSet)
		if (self.geometry as? SCNText) != nil {
			let (min, max) = boundingBox
			let dx = min.x + 0.5 * (max.x - min.x)
			let dy = min.y + 0.5 * (max.y - min.y)
			let dz = min.z + 0.5 * (max.z - min.z)
			pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
		}
    }
    
    public func setColor(_ color: Color) {
        let material = self.geometry?.firstMaterial
		switch(color){ // Missing colors: brown
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
		case .clear:
			material?.diffuse.contents = UIColor.clear
        }
    }
	
	public func setColor(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
		let material = self.geometry?.firstMaterial
		material?.diffuse.contents = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
	}
	
	public func setTexture(to prefix: String) {
		let material = self.geometry?.firstMaterial
		material?.diffuse.contents = UIImage(named: "\(prefix)-albedo.png")
		material?.roughness.contents = UIImage(named: "\(prefix)-roughness.png")
		material?.metalness.contents = 0
		material?.normal.contents = UIImage(named: "\(prefix)-normal.png")
	}
	
	public func setImage(to imageName: String) {
		if (self.geometry as? SCNPlane) != nil {
			let material = self.geometry?.firstMaterial
			material?.diffuse.contents = UIImage(named: "\(imageName).png")
		}
	}
    
    public func setShape(_ shape: Shape) {
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
		case .pyramid:
			let pyramid = newPyramid(dimension)
			self.geometry = pyramid
			setPhysicsBody(Pyramid: pyramid)
			break
		case .text:
			let text = newText(dimension)
			self.geometry = text
			break
		case .plane:
			let plane = newPlane(dimension)
			self.geometry = plane
			break
        }
    }
    
    private func setPhysicsBody(Box box: SCNBox) {
        let shape = SCNPhysicsShape(geometry: box, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        self.physicsBody?.categoryBitMask = CollisionCategory.object.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.bullet.rawValue
    }
    
    private func setPhysicsBody(Sphere sphere: SCNSphere) {
        let shape = SCNPhysicsShape(geometry: sphere, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        if isBullet {
            self.physicsBody?.categoryBitMask = CollisionCategory.bullet.rawValue
            self.physicsBody?.contactTestBitMask = CollisionCategory.object.rawValue
        }
        else {
            self.physicsBody?.categoryBitMask = CollisionCategory.object.rawValue
            self.physicsBody?.contactTestBitMask = CollisionCategory.bullet.rawValue
        }
    }
	
	private func setPhysicsBody(Ring ring: SCNTorus) {
		let shape = SCNPhysicsShape(geometry: ring, options: nil)
		self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
		self.physicsBody?.isAffectedByGravity = false
		
		self.physicsBody?.categoryBitMask = CollisionCategory.object.rawValue
		self.physicsBody?.contactTestBitMask = CollisionCategory.bullet.rawValue
	}
	
	private func setPhysicsBody(Pill pill: SCNCapsule) {
		let shape = SCNPhysicsShape(geometry: pill, options: nil)
		self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
		self.physicsBody?.isAffectedByGravity = false
		
		self.physicsBody?.categoryBitMask = CollisionCategory.object.rawValue
		self.physicsBody?.contactTestBitMask = CollisionCategory.bullet.rawValue
	}
	
	private func setPhysicsBody(Pyramid pyramid: SCNPyramid) {
		let shape = SCNPhysicsShape(geometry: pyramid, options: nil)
		self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
		self.physicsBody?.isAffectedByGravity = false
		
		self.physicsBody?.categoryBitMask = CollisionCategory.object.rawValue
		self.physicsBody?.contactTestBitMask = CollisionCategory.bullet.rawValue
	}
    
    private func newBox(_ dimension: Float) -> SCNBox {
        let box = SCNBox(width: CGFloat(dimension * multiplier),
                     height: CGFloat(dimension * multiplier) ,
                     length: CGFloat(dimension * multiplier),
                     chamferRadius: CGFloat(0.0))
        return box
    }
	
	private func newSphere(_ dimension: Float) -> SCNSphere {
		let sphere = SCNSphere(radius: CGFloat(dimension * multiplier))
		return sphere
	}
	
	private func newRing(_ dimension: Float) -> SCNTorus {
		let ring = SCNTorus(
			ringRadius: CGFloat(dimension),
			pipeRadius: CGFloat(dimension/2))
		return ring
	}
	
	private func newPill(_ dimension: Float) -> SCNCapsule {
		let pill = SCNCapsule(capRadius: CGFloat(dimension/2), height: CGFloat(dimension))
		return pill
	}
	
	private func newPyramid(_ dimension: Float) -> SCNPyramid {
		let pyramid = SCNPyramid(width: CGFloat(dimension), height: CGFloat(dimension), length: CGFloat(dimension))
		return pyramid
	}
	
	private func newText(_ dimension: Float) -> SCNText {
		var text = SCNText(string: name, extrusionDepth: CGFloat(dimension))
		if !useNameForText {
			text = SCNText(string: customText, extrusionDepth: CGFloat(dimension))
		}
		scale = SCNVector3(dimension, dimension, dimension)
		text.font = UIFont.init(name: "Helvetica", size: 1)
		if customText != "" {
			text.containerFrame = CGRect(x: CGFloat(self.position.x),
										 y: CGFloat(self.position.y),
										 width: CGFloat(7),
										 height: CGFloat(6))
		}
		text.isWrapped = true
		text.alignmentMode = kCAAlignmentCenter
		return text
	}
	
	private func newPlane(_ dimension: Float) -> SCNPlane {
		let plane = SCNPlane(width: CGFloat(dimension*multiplier), height: CGFloat(dimension*multiplier))
		return plane
	}
	
	public func followCamera(_ node: SCNNode) {
		let constraint = SCNBillboardConstraint()
		constraint.freeAxes = .Y
		constraints = [constraint]
	}
}
