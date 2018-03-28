//
//  CircuitSceneViewController.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class CircuitSceneViewController : NSObject {
    init(circuit: Circuit = Circuit()) {
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

    var circuit: Circuit

    private let tickInterval: TimeInterval = 0.1

    private lazy var scene: SCNScene = {
        guard let scene = SCNScene(named: circuitSceneName) else { fatalError() }
        return scene
    }()

    private(set) lazy var view: SCNView = {
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
    func didAdd(component: Composable, at position: GridPoint) {
        let controller = nodeController(for: component)
        controller.node.position = SCNVector3(position.x, 0, position.y)

        scene.rootNode.addChildNode(controller.node)
        componentNodeControllers[position] = controller
    }

    func didUpdate(component: Composable, at position: GridPoint) {
        guard var controller = componentNodeControllers[position] else { return }
        controller.component = component
    }

    func didRemove(component: Composable, at position: GridPoint) {
        componentNodeControllers[position]?.node.removeFromParentNode()
        componentNodeControllers[position] = nil
    }
}

extension CircuitSceneViewController {
    func position(at point: CGPoint) -> GridPoint? {
        let hits = view.hitTest(point, options: nil)
        guard let coordinates = hits.first?.worldCoordinates else { return nil }
        return GridPoint(point: CGPoint(x: Double(coordinates.x), y: Double(coordinates.z)))
    }
}
