//
//  IMenu.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/27/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation

protocol Menu {
    var size: Int { get set }
    var options: [ObjectNode] { get set }
    init()
    func initMenu(_ dimension: Float)
    func initOption(_ index: Int, _ name: String, _ geometry: Shape, _ color: Color)
    func initOption(_ index: Int, _ name: String, _ geometry: Shape, _ texture: String) 
    func setOptionPositions(_ x: Float, _ y: Float, _ z: Float)
    func show()
}
