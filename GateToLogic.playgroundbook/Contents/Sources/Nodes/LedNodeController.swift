//
//  LedNode.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class LedNodeController : NodeControlling {
    init(led: Led) {
        self.led = led
    }

    lazy var node: SCNNode = {
        guard
            let scene = SCNScene(named: componentsSceneName),
            let node = scene.rootNode.childNode(withName: "Led", recursively: true)
        else { fatalError() }
        node.geometry?.materials = [.zeroLed]
        return node
    }()

    lazy var leftNode: SCNNode = {
        guard let node = node.childNode(withName: "Led-LeftWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    var led: Led {
        didSet {
            node.geometry?.materials = [led.value ? .oneLed : .zeroLed]
            leftNode.geometry?.materials = [led.value ? .oneComponent : .zeroComponent]
        }
    }
}
