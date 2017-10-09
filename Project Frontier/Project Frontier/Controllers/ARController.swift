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

class ARController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, UIGestureRecognizerDelegate, ContainerDelegateProtocol {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var scopeImage: UIImageView!
    @IBOutlet weak var startContainer: UIView!
    
    let ARPlaneDetectionNone: UInt = 0
	let framesPerSecond: Float = 60.0
	
	var bulletsFrames: Float = 0.0
    var isPlacingNodes: Bool = true
    var configuration = ARWorldTrackingConfiguration()
    var planes = [UUID: SurfacePlane]()
    var objects: [ObjectNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupRecognizers()
        // Stops screen from dimmming if the application is runnning
        UIApplication.shared.isIdleTimerDisabled = true
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
    
    func setupSession(){
        //configuration.isLightEstimationEnabled = true
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func setupScene(){
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        // sceneView.showsStatistics = true
        // add some default lighting in the 3D scene
        //sceneView.autoenablesDefaultLighting = true
        
        // Make things look prettier
        sceneView.antialiasingMode = SCNAntialiasingMode.multisampling4X
        
        // Debug plane
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Create a new scene
        let scene = SCNScene()
		
		scene.physicsWorld.contactDelegate = self

        // Set the scene to the view
        sceneView.scene = scene
    }
	
	func setupLighting(){
		let env = UIImage(named: "spherical.jpg")
		sceneView.scene.lightingEnvironment.contents = env
		sceneView.scene.lightingEnvironment.intensity = 2.0
	}
    
    func setupRecognizers(){
        // Single tap will insert a new piece of geometry into the scene
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap (from recognizer: UITapGestureRecognizer){
        if isPlacingNodes {
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
        } else {
			if !searchNode(for: "Bullet", from: objects) {
				let dimensions: Float = 0.010
				let bulletNode = ObjectNode(dimensions, true)
				bulletNode.setName(to: "Bullet")
				bulletNode.setShape(.sphere)
				bulletNode.setColor(.white)
				bulletNode.setPosition(
					(sceneView.session.currentFrame?.camera.transform.columns.3.x)!,
					(sceneView.session.currentFrame?.camera.transform.columns.3.y)!,
					(sceneView.session.currentFrame?.camera.transform.columns.3.z)!, 0, 0, 0)
				
				let bulletDirection = self.getUserDirection()
				bulletNode.physicsBody?.applyForce(bulletDirection, asImpulse: true)
				sceneView.scene.rootNode.addChildNode(bulletNode)
				objects.append(bulletNode)
			}
        }
    }
	
	func searchNode(for name: String, from objects: [SCNNode]) -> Bool {
		var hasNode = false
		for obj in objects {
			if obj.name == name {
				hasNode = true
				break
			}
		}
		return hasNode
	}
	
	func getNodeIndex(from objects: [SCNNode], by name: String) -> Int{
		var index = 0
		for obj in objects {
			if obj.name == name {
				return index
			}
			index+=1;
		}
		return -1
	}
    
    func newARMenu(x: Float, y: Float, z: Float) {
        let dimension: Float = 0.025
        let arMenu = ARMenu()
        
        arMenu.initMenu(dimension)
        arMenu.setOptionPositions(x, y, z)
        
        for x in stride(from: 0, to: arMenu.size, by: 1) {
            sceneView.scene.rootNode.addChildNode(arMenu.options[x])
            objects.append(arMenu.options[x])
        }
		arMenu.show()
    }
	
	func newSunsMenu(x: Float, y: Float, z: Float) {
		let dimension: Float = 0.025
		let sunMenu = SunMenu()
		
		sunMenu.initMenu(dimension)
		sunMenu.setOptionPositions(x, y, z)
		
		for x in stride(from: 0, to: sunMenu.size, by: 1) {
			sceneView.scene.rootNode.addChildNode(sunMenu.options[x])
			objects.append(sunMenu.options[x])
		}
		sunMenu.show()
	}
	
	func newYellowSun(x: Float, y: Float, z: Float) {
		let sun: YellowSun = YellowSun()
		
		sun.initSubject()
		sun.setObjectPositions(x, y, z)
		
		for x in stride(from: 0, to: sun.size, by: 1) {
			sceneView.scene.rootNode.addChildNode(sun.objects[x])
			objects.append(sun.objects[x])
		}
		sun.show()
//		var dist: Float = 0.01
//		for obj in sun.objects {
//			let anim = Animation()
//			anim.move(obj, x: obj.position.x+dist, y: obj.position.y, z: obj.position.z, d: 2)
//			dist+=dist
//		}
	}
    
    func getUserDirection() -> SCNVector3 {
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform)
            return SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
        }
        return SCNVector3(0, 0, -1)
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
    
    // MARK: - SCNPhysicsContactDelegate
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
		//print("Node [\(contact.nodeA.name)] and Node [\(contact.nodeB.name)]")
		let anim: Animation = Animation()
		bulletsFrames = 0.0
		
		contact.nodeA.addParticleSystem(anim.explode(color: .white, geometry: contact.nodeA.geometry!))
		
		if searchNode(for: "Bullet", from: objects) {
			contact.nodeB.removeFromParentNode()
			objects.remove(at: getNodeIndex(from: objects, by: "Bullet")) // TODO: BulletNode exist remove it
		}
			
		if contact.nodeA.name == "Sun" {
			for obj in objects {
				//anim.disappear(obj, d: 1)
				obj.removeFromParentNode()
				objects.remove(at: getNodeIndex(from: objects, by: obj.name!))
			}
			newSunsMenu(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
		}
		else if contact.nodeA.name == "Back" {
			for obj in objects {
				//anim.disappear(obj, duration: 1)
				obj.removeFromParentNode()
				objects.remove(at: getNodeIndex(from: objects, by: obj.name!))
			}
			newARMenu(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
		}
		else if contact.nodeA.name == "Yellow Sun" {
			for obj in objects {
				//anim.disappear(obj, duration: 1)
				obj.removeFromParentNode()
				objects.remove(at: getNodeIndex(from: objects, by: obj.name!))
			}
			newYellowSun(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
		}
    }
	
	func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
		print("Contact Updated")
	}
	
	func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
		print("Contact Ended")
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
        let plane = SurfacePlane(with: anchor as! ARPlaneAnchor)
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
	
	func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
		if searchNode(for: "Bullet", from: objects) {
			bulletsFrames+=1
			if bulletsFrames == (framesPerSecond * (objects.first?.multiplier)!) { //Bullet disappears in 2 seconds
				let node = objects.remove(at: getNodeIndex(from: objects, by: "Bullet"))
				node.removeFromParentNode()
				bulletsFrames = 0.0
			}
		}
	}
    
    // MARK: - Delegate Protocols
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Check for the right segue by name
        (segue.destination as! StartController).delegate = self
    }
    
    func close() {
        startContainer.isHidden = true
    }
    
    // MARK: - Button Outlets
    
    @IBAction func resetView(_ sender: Any) {
        if !isPlacingNodes {
            isPlacingNodes = true
            scopeImage.isHidden = true
            plusButton.isHidden = false
            PointOnPlane.reset()
            for object in objects {
                object.removeFromParentNode()
            }
            objects = []
            sceneView.session.run(configuration, options: .removeExistingAnchors)
            sceneView.session.run(configuration, options: .resetTracking)
        }
    }
    
    @IBAction func initModels(_ sender: Any) {
        if PointOnPlane.hasPoint {
            isPlacingNodes = false
            plusButton.isHidden = true
            scopeImage.isHidden = false
            newARMenu(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
            hidePlanes()
        }
    }
    
}
