//
//  PointOnPlane.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/17/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation

struct PointOnPlane {
    static var x: Float = 0
    static var y: Float = 0
    static var z: Float = 0
    static var hasPoint = false
    
    static func reset(){
        PointOnPlane.x = 0
        PointOnPlane.y = 0
        PointOnPlane.z = 0
        PointOnPlane.hasPoint = false;
    }
}
