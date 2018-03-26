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

    lazy var socketNode: SCNNode = {
        guard let node = node.childNode(withName: "Led-Socket", recursively: true) else { fatalError() }
        node.geometry?.materials = [.zeroLed]
        return node
    }()

    lazy var lightNode: SCNNode = {
        guard let node = node.childNode(withName: "Led-Light", recursively: true) else { fatalError() }
        node.light = SCNLight()
        node.light?.temperature = 128
        node.light?.intensity = 0
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
            socketNode.geometry?.materials = [led.value ? .oneLed : .zeroLed]
            lightNode.light?.intensity = led.value ? 1 : 0
            leftNode.geometry?.materials = [led.value ? .oneComponent : .zeroComponent]
        }
    }
}
