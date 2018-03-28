//
//  ConstantNodeController.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

public final class ConstantNodeController : NodeControlling {
    public init(constant: Constant) {
        component = constant
        update()
    }

    public lazy var node: SCNNode = {
        guard
            let scene = SCNScene(named: componentsSceneName),
            let node = scene.rootNode.childNode(withName: "Constant", recursively: true)
        else { fatalError() }
        node.position = SCNVector3()
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    var buttonNode: SCNNode {
        guard let node = node.childNode(withName: "Constant-Button", recursively: true) else { fatalError() }
        node.geometry?.materials = [.component]
        return node
    }

    var rightNode: SCNNode {
        guard let node = node.childNode(withName: "Constant-RightWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }

    public var component: Composable {
        didSet { update() }
    }

    private func update() {
        guard let constant = component as? Constant else { fatalError() }

        buttonNode.isHidden = constant.value
        node.geometry?.materials = [constant.value ? .oneComponent : .zeroComponent]
        rightNode.geometry?.materials = [constant.value ? .oneComponent : .zeroComponent]
    }
}
