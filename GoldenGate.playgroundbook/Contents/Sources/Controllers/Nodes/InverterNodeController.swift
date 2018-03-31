//
//  InverterNodeController.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class InverterNodeController : NodeControlling {
    init(inverter: Inverter) {
        component = inverter
        update(with: inverter)
    }

    private(set) lazy var node: SCNNode = {
        guard
            let scene = SCNScene(named: componentsSceneName),
            let node = scene.rootNode.childNode(withName: "Inverter", recursively: true)
        else { fatalError() }
        node.position = SCNVector3()
        node.geometry?.materials = [.component]
        return node
    }()

    private lazy var inverterNode: SCNNode = {
        guard let node = node.childNode(withName: "Inverter-One", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    private lazy var leftNode: SCNNode = {
        guard let node = node.childNode(withName: "Inverter-LeftWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    private lazy var rightNode: SCNNode = {
        guard let node = node.childNode(withName: "Inverter-RightWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    private lazy var connectorNode: SCNNode = {
        guard let node = node.childNode(withName: "Inverter-Connector", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    var component: Composable {
        didSet {
            guard let inverter = component as? Inverter, let oldInverter = oldValue as? Inverter else { fatalError() }
            guard inverter != oldInverter else { return }
            update(with: inverter)
        }
    }

    private func update(with inverter: Inverter) {
        inverterNode.geometry?.materials = [.material(for: inverter.state)]
        leftNode.geometry?.materials = [.material(for: inverter[.left])]
        rightNode.geometry?.materials = [.material(for: inverter[.right])]
        connectorNode.geometry?.materials = [.material(for: inverter[.right])]
    }
}
