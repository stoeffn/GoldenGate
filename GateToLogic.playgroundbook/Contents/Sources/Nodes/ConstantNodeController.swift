//
//  ConstantNodeController.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class ConstantNodeController : NodeControlling {
    init(constant: Constant) {
        component = constant
        update()
    }

    private(set) lazy var node: SCNNode = {
        guard
            let scene = SCNScene(named: componentsSceneName),
            let node = scene.rootNode.childNode(withName: "Constant", recursively: true)
        else { fatalError() }
        node.position = SCNVector3()
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    private lazy var buttonNode: SCNNode = {
        guard let node = node.childNode(withName: "Constant-Button", recursively: true) else { fatalError() }
        node.geometry?.materials = [.component]
        return node
    }()

    private lazy var rightNode: SCNNode = {
        guard let node = node.childNode(withName: "Constant-RightWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    var component: Composable {
        didSet { update() }
    }

    private func update() {
        guard let constant = component as? Constant else { fatalError() }

        buttonNode.isHidden = constant.value
        node.geometry?.materials = [constant.value ? .oneComponent : .zeroComponent]
        rightNode.geometry?.materials = [constant.value ? .oneComponent : .zeroComponent]
    }
}
