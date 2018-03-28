//
//  GateNodeController.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

public final class GateNodeController : NodeControlling {
    public init(gate: Gate) {
        component = gate
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

    lazy var andNode: SCNNode = {
        guard let node = node.childNode(withName: "Gate-And", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    lazy var orNode: SCNNode = {
        guard let node = node.childNode(withName: "Gate-Or", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    lazy var leftNode: SCNNode = {
        guard let node = node.childNode(withName: "Gate-LeftWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    lazy var topNode: SCNNode = {
        guard let node = node.childNode(withName: "Gate-TopWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    lazy var rightNode: SCNNode = {
        guard let node = node.childNode(withName: "Gate-RightWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    lazy var bottomNode: SCNNode = {
        guard let node = node.childNode(withName: "Gate-BottomWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    public var component: Composable {
        didSet { update() }
    }

    private func update() {
        guard let gate = component as? Gate else { fatalError() }

        andNode.isHidden = gate.operator != .and
        andNode.geometry?.materials = [.material(for: gate.state)]
        orNode.isHidden = gate.operator != .or
        orNode.geometry?.materials = [.material(for: gate.state)]

        leftNode.isHidden = gate[.left] == .unknown
        leftNode.geometry?.materials = [.material(for: gate[.left])]
        topNode.isHidden = gate[.top] == .unknown
        topNode.geometry?.materials = [.material(for: gate[.top])]
        rightNode.isHidden = gate.state == .unknown
        rightNode.geometry?.materials = [.material(for: gate.state)]
        bottomNode.isHidden = gate[.bottom] == .unknown
        bottomNode.geometry?.materials = [.material(for: gate[.bottom])]
    }
}
