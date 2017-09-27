//
//  Subject.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/27/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation

protocol Subject {
    var size: Int { get set}
    var objects: [ObjectNode] { get set}
    init()
    func initSubject()
    func initObject(_ index: Int, _ name: String, _ size: Float, _ geometry: Shape, _ color: Color)
    func initObject(_ index: Int, _ name: String, _ size: Float, _ geometry: Shape, _ r: Float, _ g: Float, _ b: Float, _ a: Float)
    func setObjectPositions(_ x: Float, _ y: Float, _ z: Float)
    func show()
    func hide()
}
