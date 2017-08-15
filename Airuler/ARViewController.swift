//
//  ViewController.swift
//  Airuler
//
//  Created by Parth Desai on 8/1/17.
//  Copyright © 2017 Parth Desai. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

@available(iOS 11.0, *)
@available(iOS 11.0, *)
@available(iOS 11.0, *)
@available(iOS 11.0, *)
final class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var measurement: UILabel!
    @IBOutlet weak var loading: UILabel!
    @IBOutlet var aim: UIImageView!
    @IBOutlet var sceneView: ARSCNView!
    
    let session = ARSession()
    let vectorZero = SCNVector3()
    let sessionConfig: ARSessionConfiguration = ARWorldTrackingSessionConfiguration()
    var measuring = false
    var startValue = SCNVector3()
    var endValue = SCNVector3()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Airuler"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackOpaque
        
        setupScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }
    
    func setupScene() {
        sceneView.delegate = self
        sceneView.session = session
        
        session.run(sessionConfig, options: [.resetTracking, .removeExistingAnchors])
        
        resetValues()
    }
    
    func resetValues() {
        measuring = false
        startValue = SCNVector3()
        endValue = SCNVector3()
        
        updateResultLabel(0.0)
    }
    
    func updateResultLabel(_ value: Float) {
        let cm = value * 100.0
        let inch = cm * 0.3937007874
        let feet = cm * 0.03
        measurement.text = String(format: "%.1f centimeters" + " | " + "%.1f inches" + " | " + "%.2f feet", cm, inch, feet)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.detectObjects()
        }
    }
    
    func detectObjects() {
        if let worldPos = sceneView.realWorldVector(screenPos: view.center) {
            aim.isHidden = false
            loading.isHidden = true
            if measuring {
                if startValue == vectorZero {
                    startValue = worldPos
                }
                
                endValue = worldPos
                updateResultLabel(startValue.distance(from: endValue))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetValues()
        measuring = true
        aim.isHighlighted = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        measuring = false
        aim.isHighlighted = false
    }
    
}
