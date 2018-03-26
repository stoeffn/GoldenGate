//
//  CircuitSceneViewController.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

public final class CircuitSceneViewController : NSObject {
    public init(circuit: Circuit = Circuit()) {
        self.circuit = circuit

        super.init()

        self.circuit.positionedComponents.forEach(didAdd)
        self.circuit.didAdd = { [weak self] in self?.didAdd(component: $0, at: $1) }
        self.circuit.didUpdate = { [weak self] in self?.didUpdate(component: $0, at: $1) }
        self.circuit.didRemove = { [weak self] in self?.didRemove(component: $0, at: $1) }

        Timer.scheduledTimer(withTimeInterval: tickInterval, repeats: true) { [weak self] _ in
            self?.circuit.tick()
        }
    }

    public var circuit: Circuit

    private let tickInterval: TimeInterval = 0.1

    private lazy var scene: SCNScene = {
        guard let scene = SCNScene(named: circuitSceneName) else { fatalError() }
        return scene
    }()

    public private(set) lazy var view: SCNView = {
        let view = SCNView()
        view.scene = scene
        #if os(OSX)
            view.isJitteringEnabled = true
        #endif
        return view
    }()

    private lazy var componentNodeControllers = [GridPoint: NodeControlling]()
}

private extension CircuitSceneViewController {
    func nodeController(for component: Composable) -> NodeControlling {
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

    func didAdd(component: Composable, at position: GridPoint) {
        let controller = nodeController(for: component)
        controller.node.position = SCNVector3(position.x, 0, position.y)

        scene.rootNode.addChildNode(controller.node)
        componentNodeControllers[position] = controller
    }

    func didUpdate(component: Composable, at position: GridPoint) {
        guard let controller = componentNodeControllers[position] else { return }

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

    func didRemove(component: Composable, at position: GridPoint) {
        componentNodeControllers[position]?.node.removeFromParentNode()
        componentNodeControllers[position] = nil
    }
}

public extension CircuitSceneViewController {
    func position(at point: CGPoint) -> GridPoint? {
        let hits = view.hitTest(point, options: nil)
        guard let coordinates = hits.first?.worldCoordinates else { return nil }
        return GridPoint(point: CGPoint(x: Double(coordinates.x), y: Double(coordinates.z)))
    }
}
