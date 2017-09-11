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

class ARController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let ARPlaneDetectionNone: UInt = 0
    
    var configuration = ARWorldTrackingConfiguration()
    var planes = [UUID: SurfacePlane]()
    // Contains a list of all the boxes in the scene
    var boxes: [SCNNode] = []
    // Point where the use tapped on the plane
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
    
    struct CollisionCategory : OptionSet {
        let rawValue: Int
        
        static let bottom = CollisionCategory(rawValue: 1 << 0)
        static let cube = CollisionCategory(rawValue: 1 << 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated
        
    }
    
    func setupScene(){
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // add some default lighting in the 3D scene
        sceneView.autoenablesDefaultLighting = true
        
        // Debug plane
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Create a new scene
        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene
    }
    
    func setupSession(){
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func setupRecognizers(){
        // Single tap will insert a new piece of geometry into the scene
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        // Press and hold will cause all the planes to disappear
        let hidePlanesGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleHidePlane))
        hidePlanesGestureRecognizer.minimumPressDuration = 1
        sceneView.addGestureRecognizer(hidePlanesGestureRecognizer)
    }
    
    @objc func handleTap (from recognizer: UITapGestureRecognizer){
        // Take the screen tap coordinates and pass them to the hitTest method on the ARSCNView instance
        let tapPoint: CGPoint = recognizer.location(in: sceneView)
        let result: [ARHitTestResult] = sceneView.hitTest(tapPoint, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
        // If the intersection ray passes through any plane geometry they will be returned with the planes
        // ordered by distance from the camera
        if result.count == 0 {
            return
        }
        
        // If there are multiple hits, just pick the closest plane
        let hitResult: ARHitTestResult? = result.first
        
        PointOnPlane.x = hitResult!.worldTransform.columns.3.x
        PointOnPlane.y = hitResult!.worldTransform.columns.3.y
        PointOnPlane.z = hitResult!.worldTransform.columns.3.z
        PointOnPlane.hasPoint = true
    }
    
    @objc func handleHidePlane(from recognizer: UITapGestureRecognizer) {
        if recognizer.state != .began {
            return
        }
        hidePlanes()
    }
    
    func insertGeometry(x: Float, y: Float, z: Float){
        let dimension: Float = 0.1
        let cube = SCNBox(
            width: CGFloat(dimension),
            height: CGFloat(dimension),
            length: CGFloat(dimension), 
            chamferRadius: 0)
        let node = SCNNode(geometry: cube)
        // We insert the geometry slightly above the point the user tapped
        // to make it float
        let insertionYOffSet: Float = 0.15
        node.position = SCNVector3Make(x, y + insertionYOffSet, z)
        // Add the cube to the scene
        sceneView.scene.rootNode.addChildNode(node)
        // Add the cube to an internal list for book keeping
        boxes.append(node)
    }
    
    func hidePlanes(){
        // Hide all planes
        for planeId in planes {
            planes[planeId.key]?.isHidden = true
        }
        // Stop detecting new planes or updating existing ones.
        let configuration: ARWorldTrackingConfiguration? = (sceneView.session.configuration as? ARWorldTrackingConfiguration)
        configuration?.planeDetection = .init(rawValue: ARPlaneDetectionNone)
        sceneView.session.run(configuration!)
    }

    // MARK: - ARSCNViewDelegate
    
    /**
     // Override to create and configure nodes for anchors added to the view's session.
     override func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
    */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("Error: \(error.localizedDescription)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if (!(anchor is ARPlaneAnchor)) {
            return
        }
        // When a new plane is detected we create a new SceneKit plane to visualize it in 3D
        let plane = SurfacePlane.init(with: anchor as! ARPlaneAnchor)
        planes[anchor.identifier] = plane
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let plane = planes[anchor.identifier] {
            // When an anchor is updated we need to also update our 3D geometry too. For example
            // the width and height of the plane detection may have changed so we need to update
            // our SceneKit geometry to match that
            plane.update(anchor: anchor as! ARPlaneAnchor)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let _ = planes[anchor.identifier] {
            // Nodes will be removed if planes multiple individual planes that are detected to all be
            // part of a larger plane are merged.
            planes.remove(at: planes.index(forKey: anchor.identifier)!)
        }
    }
    
    // MARK: - Button Outlets
    
    @IBAction func refreshView(_ sender: Any) {
        PointOnPlane.reset()
        for box in boxes {
            box.removeFromParentNode()
        }
        boxes = []
        sceneView.session.run(configuration, options: .removeExistingAnchors)
        sceneView.session.run(configuration, options: .resetTracking)
    }
    
    @IBAction func initModels(_ sender: Any) {
        if PointOnPlane.hasPoint {
            insertGeometry(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
            hidePlanes()
        }
    }
    
}
