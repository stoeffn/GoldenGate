//
//  GameViewController.swift
//  GateToLogicSandbox
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit
import QuartzCore

final class GameViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

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

        print(circuit)
        circuit.tick()
        print(circuit)

        let scene = SCNScene()

        guard let scnView = self.view as? SCNView else { fatalError() }
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
    }
}
