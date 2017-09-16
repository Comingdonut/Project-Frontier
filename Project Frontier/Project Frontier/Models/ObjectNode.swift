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
    
    var dimension: Float
    var multiplier: Float // Small = 1.0, Medium = 2.0, Large = 3.0
    
    override init() {
        dimension = 0.05
        multiplier = 1.0
        super.init()
    }
    
    init(_ dimension: Float) {
        self.dimension = dimension
        multiplier = 1.0
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPosition(_ x: Float, _ y: Float, _ z: Float, _ xOffSet: Float, _ yOffSet: Float, _ zOffSet: Float) {
        self.position = SCNVector3Make(x + xOffSet, y + yOffSet, z + zOffSet)
    }
    
    func setColor(_ color: Color) {
        let materials = self.geometry?.materials as [SCNMaterial]?
        let material = materials![0]
        switch(color){
        case .red:
            material.diffuse.contents = UIColor.red
            break
        case .orange:
            material.diffuse.contents = UIColor.orange
            break
        case .yellow:
            material.diffuse.contents = UIColor.yellow
            break
        case .green:
            material.diffuse.contents = UIColor.green
            break
        case .blue:
            material.diffuse.contents = UIColor.blue
            break
        case .purple:
            material.diffuse.contents = UIColor.purple
            break
        case .white:
            material.diffuse.contents = UIColor.white
            break
        case .gray:
            material.diffuse.contents = UIColor.gray
            break
        case .black:
            material.diffuse.contents = UIColor.black
            break
        }
    }
    
    func setShape(shape: Shape) {
        switch(shape){
        case .box:
            let box = newBox(dimension)
            self.geometry = box
            break
        case .sphere:
            let sphere = newSphere(dimension)
            self.geometry = sphere
            break
        }
    }
    
    func newSphere(_ dimension: Float) -> SCNSphere {
        let sphere = SCNSphere(radius: CGFloat(dimension * multiplier))
        return sphere
    }
    
    func newBox(_ dimension: Float) -> SCNBox {
        let box = SCNBox(width: CGFloat(dimension * multiplier),
                     height: CGFloat(dimension * multiplier) ,
                     length: CGFloat(dimension * multiplier),
                     chamferRadius: CGFloat(0.0))
        return box
    }
}
