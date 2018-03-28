//
//  InverterNodeController.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

public final class InverterNodeController : NodeControlling {
    public init(inverter: Inverter) {
        component = inverter
        update()
    }

    public lazy var node: SCNNode = {
        guard
            let scene = SCNScene(named: componentsSceneName),
            let node = scene.rootNode.childNode(withName: "Gate", recursively: true)
        else { fatalError() }
        node.position = SCNVector3()
        node.geometry?.materials = [.component]
        return node
    }()

    lazy var inverterNode: SCNNode = {
        guard let node = node.childNode(withName: "Gate-And", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    lazy var leftNode: SCNNode = {
        guard let node = node.childNode(withName: "Gate-LeftWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    lazy var rightNode: SCNNode = {
        guard let node = node.childNode(withName: "Gate-RightWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    public var component: Composable {
        didSet { update() }
    }

    private func update() {
        guard let inverter = component as? Inverter else { fatalError() }

        node.geometry?.materials = [.material(for: inverter.state)]
        leftNode.geometry?.materials = [.material(for: inverter[.left])]
        rightNode.geometry?.materials = [.material(for: inverter[.right])]
    }
}
