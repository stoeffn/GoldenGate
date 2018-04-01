//
//  CircuitSceneViewController.swift
//  GoldenGate
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
            self?.circuit.update()
        }
    }

    var circuit: Circuit

    private let tickInterval: TimeInterval = 0.1

    private lazy var scene: SCNScene = {
        guard let scene = SCNScene(named: NodeController.circuitSceneName) else { fatalError() }
        return scene
    }()

    private(set) lazy var view: SCNView = {
        let view = SCNView()
        view.scene = scene
        #if os(OSX)
            view.isJitteringEnabled = true
            view.showsStatistics = true
        #else
            view.allowsCameraControl = true
            view.cameraControlConfiguration.autoSwitchToFreeCamera = false
            view.defaultCameraController.interactionMode = .orbitTurntable
            view.defaultCameraController.minimumVerticalAngle = 20
            view.defaultCameraController.maximumVerticalAngle = 90
        #endif
        resetCamera(view: view)
        return view
    }()

    private(set) lazy var componentNodeControllers = [GridPoint: NodeController]()

    func resetCamera(view: SCNView? = nil) {
        let view = view ?? self.view
        view.pointOfView?.position = SCNVector3(x: -8, y: 8, z: 10)
        view.pointOfView?.look(at: SCNVector3(x: 0, y: 0, z: 0))
        view.pointOfView?.camera?.orthographicScale = 6
    }
}

private extension CircuitSceneViewController {
    func didAdd(component: Composable, at position: GridPoint) {
        guard let controller = NodeController.for(component) else { fatalError() }
        controller.add(at: position, animated: true)

        scene.rootNode.addChildNode(controller.node)
        componentNodeControllers[position] = controller
    }

    func didUpdate(component: Composable, at position: GridPoint) {
        guard let controller = componentNodeControllers[position] else { return }
        controller.component = component
    }

    func didRemove(component: Composable, at position: GridPoint) {
        componentNodeControllers[position]?.remove(animated: true) {
            self.componentNodeControllers[position] = nil
        }
    }
}

extension CircuitSceneViewController {
    func position(at point: CGPoint) -> GridPoint? {
        let hits = view.hitTest(point, options: nil)
        guard let coordinates = hits.first?.worldCoordinates else { return nil }
        return GridPoint(point: CGPoint(x: Double(coordinates.x), y: Double(coordinates.z)))
    }
}
