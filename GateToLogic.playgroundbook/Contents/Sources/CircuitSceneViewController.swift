//
//  CircuitSceneViewController.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class CircuitSceneViewController : NSObject {
    deinit {
        circuit.didAddComponentAt = nil
        circuit.willRemoveComponentAt = nil
    }

    private lazy var circuit: Circuit = {
        var circuit = Circuit()
        circuit.didAddComponentAt = didAddComponent
        circuit.willRemoveComponentAt = willRemoveComponent
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

    private lazy var scene = SCNScene()

    private(set) lazy var view: SCNView = {
        let view = SCNView()
        view.scene = scene
        view.delegate = self
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.showsStatistics = true
        return view
    }()

    private lazy var componentNodes = [GridPoint: SCNNode]()
}

extension CircuitSceneViewController {
    func didAddComponent(at position: GridPoint) {
        let boxGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0)
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.position = SCNVector3(x: CGFloat(position.x), y: CGFloat(position.y), z: 0)
        scene.rootNode.addChildNode(boxNode)
        componentNodes[position] = boxNode
    }

    func willRemoveComponent(at position: GridPoint) {
        componentNodes[position]?.removeFromParentNode()
        componentNodes[position] = nil
    }
}

extension CircuitSceneViewController : SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        circuit.tick()
    }
}
