//
//  ConstantNodeController.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class ConstantNodeController : NodeControlling {
    init(constant: Constant) {
        component = constant
        update(with: constant)
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

    private lazy var pressAction: SCNAction = {
        let action = SCNAction.move(to: SCNVector3(x: 0, y: 0, z: -0.2), duration: 0.05)
        action.timingMode = .easeIn
        return action
    }()

    private lazy var releaseAction: SCNAction = {
        let action = SCNAction.move(to: SCNVector3(x: 0, y: 0, z: 0), duration: 0.05)
        action.timingMode = .easeIn
        return action
    }()

    var component: Composable {
        didSet {
            guard let constant = component as? Constant, let oldConstant = oldValue as? Constant else { fatalError() }
            guard constant != oldConstant else { return }
            update(with: constant)
        }
    }

    private func update(with constant: Constant) {
        buttonNode.removeAllActions()
        buttonNode.runAction(constant.value ? pressAction : releaseAction)
        buttonNode.geometry?.materials = [constant.value ? .oneComponent : .zeroComponent]

        rightNode.geometry?.materials = [constant.value ? .oneComponent : .zeroComponent]
    }
}
