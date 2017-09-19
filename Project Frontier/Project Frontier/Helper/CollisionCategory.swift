//
//  CollisionCategory.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/17/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation

struct CollisionCategory: OptionSet {
    let rawValue: Int
    
    static let bullet = CollisionCategory(rawValue: 1 >> 0)
    static let object = CollisionCategory(rawValue: 1 >> 1)
}
