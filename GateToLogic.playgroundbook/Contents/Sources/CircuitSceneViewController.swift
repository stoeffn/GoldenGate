//
//  CircuitSceneViewController.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class CircuitSceneViewController : NSObject {
    lazy var circuit: Circuit = {
        var circuit = Circuit()
        circuit.didAdd = { [weak self] in self?.didAdd(component: $0, at: $1) }
        circuit.didUpdate = { [weak self] in self?.didUpdate(component: $0, at: $1) }
        circuit.didRemove = { [weak self] in self?.didRemove(component: $0, at: $1) }
        return circuit
    }()

    private lazy var scene: SCNScene = {
        guard let scene = SCNScene(named: "CircuitScene.scn") else { fatalError() }
        return scene
    }()

    private(set) lazy var view: SCNView = {
        let view = SCNView()
        view.scene = scene
        view.delegate = self
        view.showsStatistics = true
        return view
    }()

    private lazy var componentNodeControllers = [GridPoint: NodeControlling]()
}

extension CircuitSceneViewController {
    private func nodeController(for component: Composable) -> NodeControlling {
        switch component {
        case let constant as Constant:
            return ConstantNodeController(constant: constant)
        case let gate as Gate:
            return GateNodeController(gate: gate)
        case let led as Led:
            return LedNodeController(led: led)
        case let wire as Wire:
            return WireNodeController(wire: wire)
        default:
            fatalError("Cannot create node controller for component \(component).")
        }
    }

    private func didAdd(component: Composable, at position: GridPoint) {
        let controller = nodeController(for: component)
        controller.node.position = SCNVector3(position.x, 0, position.y)

        scene.rootNode.addChildNode(controller.node)
        componentNodeControllers[position] = controller
    }

    private func didUpdate(component: Composable, at position: GridPoint) {
        guard let controller = componentNodeControllers[position] else { fatalError() }

        switch (component, controller) {
        case let (constant, controller) as (Constant, ConstantNodeController):
            controller.constant = constant
        case let (gate, controller) as (Gate, GateNodeController):
            controller.gate = gate
        case let (led, controller) as (Led, LedNodeController):
            controller.led = led
        case let (wire, controller) as (Wire, WireNodeController):
            controller.wire = wire
        default:
            fatalError("Cannot update controller \(controller) with component \(component).")
        }
    }

    private func didRemove(component: Composable, at position: GridPoint) {
        componentNodeControllers[position]?.node.removeFromParentNode()
        componentNodeControllers[position] = nil
    }
}

extension CircuitSceneViewController {
    func position(at point: CGPoint) -> GridPoint? {
        let hits = view.hitTest(point, options: nil)
        guard let coordinates = hits.first?.worldCoordinates else { return nil }
        return GridPoint(point: CGPoint(x: coordinates.x, y: coordinates.z))
    }

    func set(_ component: Composable, at point: CGPoint) {
        guard let position = self.position(at: point) else { return }
        circuit[position] = component
    }
}

extension CircuitSceneViewController : SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        circuit.tick()
    }
}
