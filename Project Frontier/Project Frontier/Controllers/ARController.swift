//
//  ARController.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/5/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARController: UIViewController{
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after the view is loaded, typically from a nib
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(configuration)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated
        
    }
    
    @IBAction func addBox(_ sender: Any) {
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        cubeNode.position = SCNVector3(0, 0, -0.5)
        sceneView.scene.rootNode.addChildNode(cubeNode)
        print("Added Box")
    }
    
    @IBAction func addSphere(_ sender: Any) {
        let earthNode = SCNNode(geometry: SCNSphere(radius: 0.1))
        earthNode.position = SCNVector3(0, 0, -0.5)
        sceneView.scene.rootNode.addChildNode(earthNode)
        print("Added Earth")
    }
    
}
