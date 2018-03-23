//
//  GameViewController.swift
//  GateToLogicSandbox
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class GameViewController : NSViewController {
    private lazy var circuit: Circuit = {
        var circuit = Circuit()
        circuit.add(Constant(position: GridPoint(x: 0, y: 0), value: true))
        circuit.add(Wire(position: GridPoint(x: 1, y : 0), orientations: [.left, .right]))
        circuit.add(Wire(position: GridPoint(x: 2, y : 0), orientations: [.left, .bottom, .right]))
        circuit.add(Wire(position: GridPoint(x: 3, y : 0), orientations: [.left, .right]))
        circuit.add(Wire(position: GridPoint(x: 2, y : 1), orientations: [.top, .bottom]))
        circuit.add(Gate(position: GridPoint(x: 2, y : 2), operator: .and))
        circuit.add(Wire(position: GridPoint(x: 3, y : 2), orientations: [.left, .right]))
        circuit.add(Led(position: GridPoint(x: 4, y: 0)))
        circuit.add(Led(position: GridPoint(x: 4, y: 2)))
        return circuit
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = SCNScene()

        guard let sceneView = view as? SCNView else { fatalError() }
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
    }
}

extension GameViewController : SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        circuit.tick()
    }
}
