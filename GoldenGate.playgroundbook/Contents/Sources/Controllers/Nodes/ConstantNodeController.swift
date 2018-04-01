//
//  ConstantNodeController.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class ConstantNodeController : NodeController {
    // MARK: - Life Cycle

    init?(constant: Constant) {
        super.init(component: constant)
        update(with: constant)
    }

    // MARK: - Nodes

    private lazy var buttonNode: SCNNode = {
        guard let node = node.childNode(withName: "\(componentName)-Button", recursively: true) else { fatalError() }
        node.geometry?.materials = [.component]
        return node
    }()

    private lazy var rightNode: SCNNode = {
        guard let node = node.childNode(withName: "\(componentName)-RightWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    // MARK: - Actions

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

    // MARK: Managing Components

    override var component: Composable {
        didSet {
            guard let constant = component as? Constant, let oldConstant = oldValue as? Constant else { fatalError() }
            guard constant != oldConstant else { return }
            update(with: constant)

            guard
                constant.isOn != oldConstant.isOn,
                let audioSource = SCNAudioSource(named: "\(NodeController.circuitAssetsFolder)/Switch.wav")
            else { return }

            let audioPlayer = SCNAudioPlayer(source: audioSource)
            node.addAudioPlayer(audioPlayer)
        }
    }

    private func update(with constant: Constant) {
        buttonNode.removeAllActions()
        buttonNode.runAction(constant.isOn ? pressAction : releaseAction)
        buttonNode.geometry?.materials = [constant.isOn ? .oneComponent : .zeroComponent]

        rightNode.geometry?.materials = [constant.isOn ? .oneComponent : .zeroComponent]
    }
}
