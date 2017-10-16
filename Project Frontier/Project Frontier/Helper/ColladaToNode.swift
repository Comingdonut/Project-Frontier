//
//  ColladaToNode.swift
//  Project Frontier
//
//  Created by James Castrejon on 10/16/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import Foundation
import SceneKit

struct ColladaToNode {
    static func colladaToNode(filePath: String) -> SCNNode {
        let node = SCNNode()
        let scene = SCNScene(named: filePath)
        let nodeArray = scene!.rootNode.childNodes
        
        for childNode in nodeArray {
            node.addChildNode(childNode as SCNNode)
        }
        return node
    }
}
