//
//  InverterNodeController.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class InverterNodeController : NodeController {
    init(inverter: Inverter) {
        super.init(component: inverter, componentName: "Inverter")
        update(with: inverter)
    }

    private lazy var inverterNode: SCNNode = {
        guard let node = node.childNode(withName: "\(componentName)-One", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    private lazy var leftNode: SCNNode = {
        guard let node = node.childNode(withName: "\(componentName)-LeftWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    private lazy var rightNode: SCNNode = {
        guard let node = node.childNode(withName: "\(componentName)-RightWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    private lazy var connectorNode: SCNNode = {
        guard let node = node.childNode(withName: "\(componentName)-Connector", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    override var component: Composable {
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
