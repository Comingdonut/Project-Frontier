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
    
    private let ARPlaneDetectionNone: UInt = 0
	private let framesPerSecond: Float = 60.0
	
	private var index: Int = 0
	private var bulletsFrames: Float = 0.0
    private var isPlacingNodes: Bool = true
    private var configuration = ARWorldTrackingConfiguration()
    private var planes = [UUID: SurfacePlane]()
    private var objects: [ObjectNode] = []
	private var sunFacts: [ObjectNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		AudioPlayer.resetMusic()
		AudioPlayer.pickSong("Midnight Sky", "mp3")
		AudioPlayer.playMusic()
		AudioPlayer.loopMusic()
		
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
    
    private func setupSession(){
        //configuration.isLightEstimationEnabled = true
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    private func setupScene(){
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        // sceneView.showsStatistics = true
        // add some default lighting in the 3D scene
        //sceneView.autoenablesDefaultLighting = true
		setupLighting()
        
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
	
	private func setupLighting() {
		let env = UIImage(named: "spherical.jpg")
		sceneView.scene.lightingEnvironment.contents = env
		sceneView.scene.lightingEnvironment.intensity = 2.0
	}
    
    private func setupRecognizers() {
        // Single tap will insert a new piece of geometry into the scene
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
	
	private func setupSunFacts() {
		let starText: [String] = ["Yellow stars are a medium sized star.",
								  "They are three different colors:",
								  "Yellow-White, Yellow, and Yellow-Orange",
								  "Yellow stars are 5,840.33 to 13,040.33 degrees fahrenheit.",
								  "Yellow stars will live up to about 10 billion years.",
								  "Currently, our sun is about 5 billion years old.",
								  "When our sun starts dying it grows into a Giant Star.",
								  "It will grow big enough to consume earth and burn Mars.",
								  "It will shrink and become a white dwarf star.",
								  "While shrinking, it will leave behind a lot of gas.",
								  "The gas will form a cloud.",
								  "This cloud is called: Planetary Nebula."]
		for x in stride(from: 0, to: starText.count, by: 1) {
			let node = ObjectNode(0.001, false, starText[x])
			node.setName(to: "Info Text")
			node.setShape(.text)
			node.setColor(.white)
			sunFacts.append(node)
		}
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
			
			initAR()
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
				AudioPlayer.pickSound("Bullet_Fired", "wav")
				AudioPlayer.playSound()
				sceneView.scene.rootNode.addChildNode(bulletNode)
				objects.append(bulletNode)
			}
        }
    }
	
	private func initAR(){
		isPlacingNodes = false
		plusButton.isHidden = true
		scopeImage.isHidden = false
		newARMenu(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
		hidePlanes()
	}
	
	private func searchNode(for name: String, from objects: [SCNNode]) -> Bool {
		var hasNode = false
		for obj in objects {
			if obj.name == name {
				hasNode = true
				break
			}
		}
		return hasNode
	}
	
	private func getNodeIndex(from objects: [SCNNode], by name: String) -> Int {
		var index = 0
		for obj in objects {
			if obj.name == name {
				return index
			}
			index+=1;
		}
		return -1
	}
    
    private func newARMenu(x: Float, y: Float, z: Float) {
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
	
	private func newStarMenu(x: Float, y: Float, z: Float) {
		let dimension: Float = 0.025
		let starMenu = StarMenu()
		
		starMenu.initMenu(dimension)
		starMenu.setOptionPositions(x, y, z)
		
		for x in stride(from: 0, to: starMenu.size, by: 1) {
			sceneView.scene.rootNode.addChildNode(starMenu.options[x])
			objects.append(starMenu.options[x])
		}
		starMenu.show()
	}
	
	private func newYellowStar(x: Float, y: Float, z: Float) {
		let star: YellowStar = YellowStar()
		
		star.initSubject()
		star.setObjectPositions(x, y, z)
		
		for x in stride(from: 0, to: star.size, by: 1) {
			sceneView.scene.rootNode.addChildNode(star.objects[x])
			objects.append(star.objects[x])
		}
		star.show()
		star.animate()
	}
    
    private func getUserDirection() -> SCNVector3 {
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform)
            return SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
        }
        return SCNVector3(0, 0, -1)
    }
    
    private func hidePlanes(){
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
		bulletsFrames = 0.0
		
		contact.nodeA.addParticleSystem(Animation.explode(color: .white, geometry: contact.nodeA.geometry!))
		AudioPlayer.pickSound("Bullet_Contact", "wav")
		AudioPlayer.playSound()
		
		if searchNode(for: "Bullet", from: objects) {
			contact.nodeB.removeFromParentNode()
			objects.remove(at: getNodeIndex(from: objects, by: "Bullet")) // TODO: BulletNode exist remove it
		}
		
		checkForMenuStarContact(contact.nodeA)
		checkForMenuBackContact(contact.nodeA)
		checkForMenuYellowStarContact(contact.nodeA)
		checkYellowStarContact(contact.nodeA)
    }
	
	func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
		print("Contact Updated")
	}
	
	func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
		print("Contact Ended")
	}
	
	private func checkForMenuStarContact(_ nodeA: SCNNode) {
		if nodeA.name == "Star" {
			for obj in objects {
				obj.removeFromParentNode()
				objects.remove(at: getNodeIndex(from: objects, by: obj.name!))
			}
			newStarMenu(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
		}
	}
	
	private func checkForMenuBackContact(_ nodeA: SCNNode) {
		if nodeA.name == "Back" {
			for obj in objects {
				obj.removeFromParentNode()
				objects.remove(at: getNodeIndex(from: objects, by: obj.name!))
			}
			newARMenu(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
		}
	}
	
	private func checkForMenuYellowStarContact(_ nodeA: SCNNode) {
		if nodeA.name == "Yellow Star" {
			for obj in objects {
				obj.removeFromParentNode()
				objects.remove(at: getNodeIndex(from: objects, by: obj.name!))
			}
			newYellowStar(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
		}
	}
	
	private func checkYellowStarContact(_ nodeA: SCNNode){
		if sunFacts.count == 0 {
			setupSunFacts()
		}
		if nodeA.name == "Medium Star" {
			if index != sunFacts.count {
				if searchNode(for: "Info Panel", from: objects) {
					objects[getNodeIndex(from: objects, by: "Info Panel")].removeFromParentNode()
					objects.remove(at: getNodeIndex(from: objects, by: "Info Panel"))
					objects[getNodeIndex(from: objects, by: "Info Text")].removeFromParentNode()
					objects.remove(at: getNodeIndex(from: objects, by: "Info Text"))
				}
				let none: Float = 0.0
				let size: Float = 0.001
				let sizeToScale: Float = 100.0
				let textToScale: Float = 0.030
				let yOffSet: Float = 0.40
				let yTopOffSet: Float = 0.43
				let zOffSet: Float = 0.060
				let textZOffSet: Float = 0.062
				
				let node = ObjectNode(size)
				node.setName(to: "Info Panel")
				node.setShape(.plane)
				node.setImage(to: "DialogBoxMedium")
				node.setPosition(PointOnPlane.x, PointOnPlane.y, PointOnPlane.z, none, yOffSet, zOffSet)
				objects.first?.parent?.addChildNode(node)
				objects.append(node)
				sunFacts[index].setPosition(PointOnPlane.x, PointOnPlane.y, PointOnPlane.z, none, yTopOffSet, textZOffSet)
				objects.first?.parent?.addChildNode(sunFacts[index])
				objects.append(sunFacts[index])
				
				Animation.scaleUp(node, to: sizeToScale, d: Duration.light)
				Animation.scaleUp(sunFacts[index], to: textToScale, d: Duration.light)
				index+=1
			}
			else {
				for obj in objects {
					obj.removeFromParentNode()
					objects.remove(at: getNodeIndex(from: objects, by: obj.name!))
				}
				index = 0
				sunFacts = []
				newARMenu(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
			}
		}
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
		// TODO: The plus button
    }
    
}
