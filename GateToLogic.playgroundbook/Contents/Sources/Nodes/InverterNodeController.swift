//
//  InverterNodeController.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class InverterNodeController : NodeControlling {
    init(inverter: Inverter) {
        component = inverter
        update()
    }

    private(set) lazy var node: SCNNode = {
        guard
            let scene = SCNScene(named: componentsSceneName),
            let node = scene.rootNode.childNode(withName: "Gate", recursively: true)
        else { fatalError() }
        node.position = SCNVector3()
        node.geometry?.materials = [.component]
        return node
    }()

    private lazy var inverterNode: SCNNode = {
        guard let node = node.childNode(withName: "Gate-And", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    private lazy var leftNode: SCNNode = {
        guard let node = node.childNode(withName: "Gate-LeftWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    private lazy var rightNode: SCNNode = {
        guard let node = node.childNode(withName: "Gate-RightWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    var component: Composable {
        didSet { update() }
    }

    private func update() {
        guard let inverter = component as? Inverter else { fatalError() }

        node.geometry?.materials = [.material(for: inverter.state)]
        leftNode.geometry?.materials = [.material(for: inverter[.left])]
        rightNode.geometry?.materials = [.material(for: inverter[.right])]
    }
}
