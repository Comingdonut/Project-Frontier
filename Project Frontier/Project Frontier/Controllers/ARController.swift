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

class ARController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var scopeImage: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var imageDetail: UIImageView!
    
    private let ARPlaneDetectionNone: UInt = 0
	private let framesPerSecond: Float = 60.0
    private let defaults = UserDefaults.standard
	
	private var theme: Int = 0
	private var starIndex: Int = 0
	private var bulletsFrames: Float = 0.0
    private var isPlacingNodes: Bool = true
	private var ableToShoot: Bool = true
	private var soundOn: Bool = true
	private var color: Color = Color.white
    private var configuration = ARWorldTrackingConfiguration()
    private var planes = [UUID: SurfacePlane]()
    private var objects: [ObjectNode] = []
	private var sunFacts: [ObjectNode] = []
	private var wDwarfFacts: [ObjectNode] = []
	private var bDwarfFacts: [ObjectNode] = []
	private var brDwarfFacts: [ObjectNode] = []
	
    private var counter: Int = 0 {
        didSet {
            let fractionalProgress = Float(counter) / 100.0
            let animated = counter != 0
            progressBar.setProgress(fractionalProgress, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		theme = defaults.integer(forKey: KeysData.key1_theme)
		if theme == 1 {
			homeButton.setImage(UIImage(named: "HomeButtonLight"), for: UIControlState.normal)
			backButton.setImage(UIImage(named: "BackButtonLight"), for: UIControlState.normal)
			resetButton.setImage(UIImage(named: "RefreshLight"), for: UIControlState.normal)
			scopeImage.image = UIImage(named: "ScopeLight")
            progressBar.progressTintColor = UIColor(red: Theme.l_r, green: Theme.l_g, blue: Theme.l_b, alpha: Theme.a)
		}
		
		let index2 = defaults.integer(forKey: KeysData.key4_textColor)
		if index2 == 1 {
			color = Color.black
		}
		
        setupProgressBar()
        
		soundOn = defaults.bool(forKey: KeysData.key6_sound)
        
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
        // sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Create a new scene
        let scene = SCNScene()
		
		scene.physicsWorld.contactDelegate = self

        // Set the scene to the view
        sceneView.scene = scene
    }
	
	private func setupLighting() {
		let env = UIImage(named: "Environment.png")
		sceneView.scene.lightingEnvironment.contents = env
		sceneView.scene.lightingEnvironment.intensity = 2
	}
    
    private func setupRecognizers() {
        // Single tap will insert a new piece of geometry into the scene
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupProgressBar() {
        progressBar.isHidden = false
        progressBar.setProgress(0, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {//Wait
            self.counter = 0
            for _ in 0..<100 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {//Wait
                    self.counter+=1
                    return
                })
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Duration.fast.rawValue, execute: {//Wait
            self.progressBar.isHidden = true
        })
    }
	
	private func setupSunFacts() {
		let starText: [String] = [NSLocalizedString(KeysLocalize.StarFact1_Yellow, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact2_Yellow, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact3_Yellow, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact4_Yellow, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact5_Yellow, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact6_Yellow, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact7_Yellow, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact8_Yellow, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact9_Yellow, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact10_Yellow, comment: "")]
		for x in stride(from: 0, to: starText.count, by: 1) {
			let node = ObjectNode(0.001, false, starText[x])
			node.setName(to: "Info Text")
			node.setShape(.text)
			node.setColor(color)
			sunFacts.append(node)
		}
	}
	
	private func setupWDwarfFacts() {
		let starText: [String] = [NSLocalizedString(KeysLocalize.StarFact1_White, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact2_White, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact3_White, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact4_White, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact5_White, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact6_White, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact7_White, comment: "")]
		
		for x in stride(from: 0, to: starText.count, by: 1) {
			let node = ObjectNode(0.001, false, starText[x])
			node.setName(to: "Info Text")
			node.setShape(.text)
			node.setColor(color)
			wDwarfFacts.append(node)
		}
	}
	
	private func setupBDwarfFacts() {
		let starText: [String] = [NSLocalizedString(KeysLocalize.StarFact1_Black, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact2_Black, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact3_Black, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact4_Black, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact5_Black, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact6_Black, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact7_Black, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact8_Black, comment: "")]
		
		for x in stride(from: 0, to: starText.count, by: 1) {
			let node = ObjectNode(0.001, false, starText[x])
			node.setName(to: "Info Text")
			node.setShape(.text)
			node.setColor(color)
			bDwarfFacts.append(node)
		}
	}
	
	private func setupBrDwarfFacts() {
		let starText: [String] = [NSLocalizedString(KeysLocalize.StarFact1_Brown, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact2_Brown, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact3_Brown, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact4_Brown, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact5_Brown, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact6_Brown, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact7_Brown, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact8_Brown, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact9_Brown, comment: ""),
								  NSLocalizedString(KeysLocalize.StarFact10_Brown, comment: "")]
		
		for x in stride(from: 0, to: starText.count, by: 1) {
			let node = ObjectNode(0.001, false, starText[x])
			node.setName(to: "Info Text")
			node.setShape(.text)
			node.setColor(color)
			brDwarfFacts.append(node)
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
			if imageDetail.isHidden {
				if ableToShoot {
					if !searchNode(for: "Bullet", from: objects) {
						let dimensions: Float = 0.010
						let bulletNode = ObjectNode(dimensions, true)
						bulletNode.setName(to: "Bullet")
						bulletNode.setShape(.sphere)
						bulletNode.setColor(color)
						bulletNode.setPosition(
							(sceneView.session.currentFrame?.camera.transform.columns.3.x)!,
							(sceneView.session.currentFrame?.camera.transform.columns.3.y)!,
							(sceneView.session.currentFrame?.camera.transform.columns.3.z)!, 0, 0, 0)
						
						let bulletDirection = self.getUserDirection()
						bulletNode.physicsBody?.applyForce(bulletDirection, asImpulse: true)
						
						if soundOn {
							AudioPlayer.pickSound("Bullet_Fired", "wav")
							AudioPlayer.playSound()
						}
						sceneView.scene.rootNode.addChildNode(bulletNode)
						objects.append(bulletNode)
					}
				}
			}
			else {
				imageDetail.isHidden = true
				resetButton.isEnabled = true
				backButton.isEnabled = true
			}
        }
    }
	
	private func initAR(){
		isPlacingNodes = false
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
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.homeButton.isHidden = false
        })
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
	
	private func newWhiteDwarfStar(x: Float, y: Float, z: Float) {
		let star: WhiteStar = WhiteStar()
		
		star.initSubject()
		star.setObjectPositions(x, y, z)
		
		for obj in star.objects {
			sceneView.scene.rootNode.addChildNode(obj)
			objects.append(obj)
		}
		star.show()
		star.animate()
	}
	
	private func newBlackDwarfStar(x: Float, y: Float, z: Float) {
		let star: BlackStar = BlackStar()
		
		star.initSubject()
		star.setObjectPositions(x, y, z)
		
		for obj in star.objects {
			sceneView.scene.rootNode.addChildNode(obj)
			objects.append(obj)
		}
		star.show()
		star.animate()
	}
	
	private func newBrownDwarfStar(x: Float, y: Float, z: Float) {
		let star: BrownStar = BrownStar()
		
		star.initSubject()
		star.setObjectPositions(x, y, z)
		
		for obj in star.objects {
			sceneView.scene.rootNode.addChildNode(obj)
			objects.append(obj)
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
		if soundOn {
			AudioPlayer.pickSound("Bullet_Contact", "wav")
			AudioPlayer.playSound()
		}
		
		if searchNode(for: "Bullet", from: objects) {
			contact.nodeB.removeFromParentNode()
			objects.remove(at: getNodeIndex(from: objects, by: "Bullet"))
		}
		
		checkForMenuStarContact(contact.nodeA)
		checkForMenuBackContact(contact.nodeA)
		checkForMenuYellowStarContact(contact.nodeA)
		checkForMenuWhiteStarContact(contact.nodeA)
		checkForMenuBlackStarContact(contact.nodeA)
		checkForMenuBrownStarContact(contact.nodeA)
		checkYellowStarContact(contact.nodeA)
		checkWhiteDwarfContact(contact.nodeA)
		checkBlackDwarfContact(contact.nodeA)
		checkBrownDwarfContact(contact.nodeA)
		checkForPlanets(contact.nodeA)
    }
	
	func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
		print("Contact Updated")
	}
	
	func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
		print("Contact Ended")
	}
	
	private func checkForMenuStarContact(_ nodeA: SCNNode) {
		if nodeA.name == "Star" {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.homeButton.isHidden = true
            })
			let dispatchGroup = DispatchGroup()
			
			ableToShoot = false
			dispatchGroup.enter()
			for obj in objects {
				Animation.disappear(obj, d: Duration.light)
			}
			dispatchGroup.leave()
			
			dispatchGroup.notify(queue: DispatchQueue.main, execute: {//After disappear is done
				DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {//Wait
					
					for obj in self.objects {
						obj.removeFromParentNode()
						self.objects.remove(at: self.getNodeIndex(from: self.objects, by: obj.name!))
					}
					self.newStarMenu(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
					
					self.ableToShoot = true
				})
			})
		}
	}
	
	private func checkForMenuBackContact(_ nodeA: SCNNode) {
		if nodeA.name == "Back" {
			let dispatchGroup = DispatchGroup()
			
			ableToShoot = false
			dispatchGroup.enter()
			for obj in objects {
				Animation.disappear(obj, d: Duration.light)
			}
			dispatchGroup.leave()
			
			dispatchGroup.notify(queue: DispatchQueue.main, execute: {//After disappear is done
				DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {//Wait
					
					for obj in self.objects {
						obj.removeFromParentNode()
						self.objects.remove(at: self.getNodeIndex(from: self.objects, by: obj.name!))
					}
					self.newARMenu(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
					
					self.ableToShoot = true
				})
			})
		}
	}
	
	private func checkForMenuYellowStarContact(_ nodeA: SCNNode) {
		if nodeA.name == "Yellow Star" {
			DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
				self.backButton.isHidden = true
			})
			let dispatchGroup = DispatchGroup()
			
			ableToShoot = false
			dispatchGroup.enter()
			for obj in objects {
				Animation.disappear(obj, d: Duration.light)
			}
			dispatchGroup.leave()
			
			dispatchGroup.notify(queue: DispatchQueue.main, execute: {//After disappear is done
				DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {//Wait
					
					for obj in self.objects {
						obj.removeFromParentNode()
						self.objects.remove(at: self.getNodeIndex(from: self.objects, by: obj.name!))
					}
					self.newYellowStar(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
                    if self.backButton.isHidden {
                        self.backButton.isHidden = false
                    }
					self.ableToShoot = true
				})
			})
		}
	}
	
	private func checkForMenuWhiteStarContact(_ nodeA: SCNNode) {
		if nodeA.name == "White Dwarf" {
			DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
				self.backButton.isHidden = true
			})
			let dispatchGroup = DispatchGroup()
			
			ableToShoot = false
			dispatchGroup.enter()
			for obj in objects {
				Animation.disappear(obj, d: Duration.light)
			}
			dispatchGroup.leave()
			
			dispatchGroup.notify(queue: DispatchQueue.main, execute: {
				DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {
					
					for obj in self.objects {
						obj.removeFromParentNode()
						self.objects.remove(at: self.getNodeIndex(from: self.objects, by: obj.name!))
					}
					self.newWhiteDwarfStar(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
                    if self.backButton.isHidden {
                        self.backButton.isHidden = false
                    }
					self.ableToShoot = true
				})
			})
		}
	}
	
	private func checkForMenuBlackStarContact(_ nodeA: SCNNode) {
		if nodeA.name == "Black Dwarf" {
			DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
				self.backButton.isHidden = true
			})
			let dispatchGroup = DispatchGroup()
			
			ableToShoot = false
			dispatchGroup.enter()
			for obj in objects {
				Animation.disappear(obj, d: Duration.light)
			}
			dispatchGroup.leave()
			
			dispatchGroup.notify(queue: DispatchQueue.main, execute: {
				DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {
					
					for obj in self.objects {
						obj.removeFromParentNode()
						self.objects.remove(at: self.getNodeIndex(from: self.objects, by: obj.name!))
					}
					self.newBlackDwarfStar(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
                    if self.backButton.isHidden {
                        self.backButton.isHidden = false
                    }
					self.ableToShoot = true
				})
			})
		}
	}
	
	private func checkForMenuBrownStarContact(_ nodeA: SCNNode) {
		if nodeA.name == "Brown Dwarf" {
			DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
				self.backButton.isHidden = true
			})
			let dispatchGroup = DispatchGroup()
			
			ableToShoot = false
			dispatchGroup.enter()
			for obj in objects {
				Animation.disappear(obj, d: Duration.light)
			}
			dispatchGroup.leave()
			
			dispatchGroup.notify(queue: DispatchQueue.main, execute: {
				DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {
					
					for obj in self.objects {
						obj.removeFromParentNode()
						self.objects.remove(at: self.getNodeIndex(from: self.objects, by: obj.name!))
					}
					self.newBrownDwarfStar(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
                    if self.backButton.isHidden {
                        self.backButton.isHidden = false
                    }
					self.ableToShoot = true
				})
			})
		}
	}
	
	private func checkYellowStarContact(_ nodeA: SCNNode) {
		if sunFacts.count == 0 {
			setupSunFacts()
		}
		if nodeA.name == "Medium Star" {
			if starIndex != sunFacts.count {
				ableToShoot = false
				if searchNode(for: "Info Text", from: objects) {
					objects[getNodeIndex(from: objects, by: "Info Text")].removeFromParentNode()
					objects.remove(at: getNodeIndex(from: objects, by: "Info Text"))
				}
				let none: Float = 0.0
				let textToScale: Float = 0.030
				let yTopOffSet: Float = 0.43
				let textZOffSet: Float = 0.062
				
				sunFacts[starIndex].setPosition(PointOnPlane.x, PointOnPlane.y, PointOnPlane.z, none, yTopOffSet, textZOffSet)
				objects.first?.parent?.addChildNode(sunFacts[starIndex])
				objects.append(sunFacts[starIndex])
				
				Animation.scale(sunFacts[starIndex], to: textToScale, d: Duration.light)
				starIndex+=1
				
				DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {//Wait
					self.ableToShoot = true
				})
			}
			else {
				let dispatchGroup = DispatchGroup()
				ableToShoot = false
				dispatchGroup.enter()
				for obj in objects {
					Animation.disappear(obj, d: Duration.light)
				}
				dispatchGroup.leave()
				
				dispatchGroup.notify(queue: DispatchQueue.main, execute: {//After disappear is done
					DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {//Wait
					
                        self.backButton.isHidden = true
						for obj in self.objects {
							obj.removeFromParentNode()
							self.objects.remove(at: self.getNodeIndex(from: self.objects, by: obj.name!))
						}
						self.starIndex = 0
						self.sunFacts = []
						self.newStarMenu(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
						
						self.ableToShoot = true
					})
				})
			}
		}
	}
	
	private func checkWhiteDwarfContact(_ nodeA: SCNNode) {
		if wDwarfFacts.count == 0 {
			setupWDwarfFacts()
		}
		if nodeA.name == "White Dwarf Star" {
			if starIndex != wDwarfFacts.count {
				ableToShoot = false
				if searchNode(for: "Info Text", from: objects) {
					objects[getNodeIndex(from: objects, by: "Info Text")].removeFromParentNode()
					objects.remove(at: getNodeIndex(from: objects, by: "Info Text"))
				}
				let none: Float = 0.0
				let textToScale: Float = 0.030
				let yTopOffSet: Float = 0.43
				let textZOffSet: Float = 0.062
				
				wDwarfFacts[starIndex].setPosition(PointOnPlane.x, PointOnPlane.y, PointOnPlane.z, none, yTopOffSet, textZOffSet)
				objects.first?.parent?.addChildNode(wDwarfFacts[starIndex])
				objects.append(wDwarfFacts[starIndex])
				
				Animation.scale(wDwarfFacts[starIndex], to: textToScale, d: Duration.light)
				starIndex+=1
				
				DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {//Wait
					self.ableToShoot = true
				})
			}
			else {
				let dispatchGroup = DispatchGroup()
				ableToShoot = false
				dispatchGroup.enter()
				for obj in objects {
					Animation.disappear(obj, d: Duration.light)
				}
				dispatchGroup.leave()
				
				dispatchGroup.notify(queue: DispatchQueue.main, execute: {//After disappear is done
					DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {//Wait
						
                        self.backButton.isHidden = true
						for obj in self.objects {
							obj.removeFromParentNode()
							self.objects.remove(at: self.getNodeIndex(from: self.objects, by: obj.name!))
						}
						self.starIndex = 0
						self.wDwarfFacts = []
						self.newStarMenu(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
						
						self.ableToShoot = true
					})
				})
			}
		}
	}
	
	private func checkBlackDwarfContact(_ nodeA: SCNNode) {
		if bDwarfFacts.count == 0 {
			setupBDwarfFacts()
		}
        if nodeA.name == "Black Dwarf Star" {
			if starIndex != bDwarfFacts.count {
				ableToShoot = false
				if searchNode(for: "Info Text", from: objects) {
					objects[getNodeIndex(from: objects, by: "Info Text")].removeFromParentNode()
					objects.remove(at: getNodeIndex(from: objects, by: "Info Text"))
				}
				let none: Float = 0.0
				let textToScale: Float = 0.030
				let yTopOffSet: Float = 0.43
				let textZOffSet: Float = 0.062
				
				bDwarfFacts[starIndex].setPosition(PointOnPlane.x, PointOnPlane.y, PointOnPlane.z, none, yTopOffSet, textZOffSet)
				objects.first?.parent?.addChildNode(bDwarfFacts[starIndex])
				objects.append(bDwarfFacts[starIndex])
				
				Animation.scale(bDwarfFacts[starIndex], to: textToScale, d: Duration.light)
				starIndex+=1
				
				DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {//Wait
					self.ableToShoot = true
				})
			}
			else {
				let dispatchGroup = DispatchGroup()
				ableToShoot = false
				dispatchGroup.enter()
				for obj in objects {
					Animation.disappear(obj, d: Duration.light)
				}
				dispatchGroup.leave()
				
				dispatchGroup.notify(queue: DispatchQueue.main, execute: {//After disappear is done
					DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {//Wait
						
                        self.backButton.isHidden = true
						for obj in self.objects {
							obj.removeFromParentNode()
							self.objects.remove(at: self.getNodeIndex(from: self.objects, by: obj.name!))
						}
						self.starIndex = 0
						self.bDwarfFacts = []
						self.newStarMenu(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
						
						self.ableToShoot = true
					})
				})
			}
		}
	}
	
	private func checkBrownDwarfContact(_ nodeA: SCNNode) {
		if brDwarfFacts.count == 0 {
			setupBrDwarfFacts()
		}
		if nodeA.name == "Brown Dwarf Star" {
			if starIndex != brDwarfFacts.count {
				ableToShoot = false
				if searchNode(for: "Info Text", from: objects) {
					objects[getNodeIndex(from: objects, by: "Info Text")].removeFromParentNode()
					objects.remove(at: getNodeIndex(from: objects, by: "Info Text"))
				}
				let none: Float = 0.0
				let textToScale: Float = 0.030
				let yTopOffSet: Float = 0.43
				let textZOffSet: Float = 0.062
				
				brDwarfFacts[starIndex].setPosition(PointOnPlane.x, PointOnPlane.y, PointOnPlane.z, none, yTopOffSet, textZOffSet)
				objects.first?.parent?.addChildNode(brDwarfFacts[starIndex])
				objects.append(brDwarfFacts[starIndex])
				
				Animation.scale(brDwarfFacts[starIndex], to: textToScale, d: Duration.light)
				starIndex+=1
				
				DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {//Wait
					self.ableToShoot = true
				})
			}
			else {
				let dispatchGroup = DispatchGroup()
				ableToShoot = false
				dispatchGroup.enter()
				for obj in objects {
					Animation.disappear(obj, d: Duration.light)
				}
				dispatchGroup.leave()
				
				dispatchGroup.notify(queue: DispatchQueue.main, execute: {//After disappear is done
					DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {//Wait
						
						self.backButton.isHidden = true
						for obj in self.objects {
							obj.removeFromParentNode()
							self.objects.remove(at: self.getNodeIndex(from: self.objects, by: obj.name!))
						}
						self.starIndex = 0
						self.brDwarfFacts = []
						self.newStarMenu(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
						
						self.ableToShoot = true
					})
				})
			}
		}
	}
	
	private func checkForPlanets(_ nodeA: SCNNode) {
		DispatchQueue.main.async{
			switch nodeA.name {
			case "Mercury"?:
				self.setBonusDetail(NSLocalizedString(KeysLocalize.BonusFact2_Mercury, comment: ""))
				break
			case "Venus"?:
				self.setBonusDetail(NSLocalizedString(KeysLocalize.BonusFact3_Venus, comment: ""))
				break
			case "Earth"?:
				self.setBonusDetail(NSLocalizedString(KeysLocalize.BonusFact4_Earth, comment: ""))
				break
			case "Mars"?:
				self.setBonusDetail(NSLocalizedString(KeysLocalize.BonusFact5_Mars, comment: ""))
				break
			case "Jupiter"?:
				self.setBonusDetail(NSLocalizedString(KeysLocalize.BonusFact6_Jupiter, comment: ""))
				break
			case "Saturn"?:
				self.setBonusDetail(NSLocalizedString(KeysLocalize.BonusFact7_Saturn, comment: ""))
				break
			case "Uranus"?:
				self.setBonusDetail(NSLocalizedString(KeysLocalize.BonusFact8_Uranus, comment: ""))
				break
			case "Neptune"?:
				self.setBonusDetail(NSLocalizedString(KeysLocalize.BonusFact9_Neptune, comment: ""))
				break
			default:
				break
			}
		}
	}
	
	private func setBonusDetail(_ detail: String) {
		self.resetButton.isEnabled = false
		self.backButton.isEnabled = false
		self.imageDetail.isHidden = false
		self.imageDetail.image = UIImage(named: detail)
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
    
    // MARK: - Button Outlets
    
    @IBAction func resetView(_ sender: Any) {
		isPlacingNodes = true
		backButton.isHidden = true
		scopeImage.isHidden = true
		PointOnPlane.reset()
		for object in objects {
			object.removeFromParentNode()
		}
		objects = []
		sceneView.session.run(configuration, options: .removeExistingAnchors)
		sceneView.session.run(configuration, options: .resetTracking)
        setupProgressBar()
    }
    
    @IBAction func returnToPreviousMenu(_ sender: Any) {
        self.backButton.isHidden = true
		starIndex = 0
		sunFacts = []
		wDwarfFacts = []
		bDwarfFacts = []
		brDwarfFacts = []
        let dispatchGroup = DispatchGroup()
        
        ableToShoot = false
        dispatchGroup.enter()
        for obj in objects {
            Animation.disappear(obj, d: Duration.light)
        }
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {//After disappear is done
            DispatchQueue.main.asyncAfter(deadline: .now() + Duration.light.rawValue, execute: {//Wait
                
                for obj in self.objects {
                    obj.removeFromParentNode()
                    self.objects.remove(at: self.getNodeIndex(from: self.objects, by: obj.name!))
                }
                self.newARMenu(x: PointOnPlane.x, y: PointOnPlane.y, z: PointOnPlane.z)
                
                self.ableToShoot = true
            })
        })
    }
    
}
