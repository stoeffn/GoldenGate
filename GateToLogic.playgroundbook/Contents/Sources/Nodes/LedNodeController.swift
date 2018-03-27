//
//  LedNode.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

public final class LedNodeController : NodeControlling {
    public init(led: Led) {
        component = led
        update()
    }

    public lazy var node: SCNNode = {
        guard
            let scene = SCNScene(named: componentsSceneName),
            let node = scene.rootNode.childNode(withName: "Led", recursively: true)
        else { fatalError() }
        node.position = SCNVector3()
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

    public var component: Composable {
        didSet { update() }
    }

    private func update() {
        guard let led = component as? Led else { fatalError() }

        node.geometry?.materials = [led.state == .one ? .oneLed : .zeroLed]
        socketNode.geometry?.materials = [led.state == .one ? .oneLed : .zeroLed]
        lightNode.light?.intensity = led.state == .one ? 1 : 0
        leftNode.geometry?.materials = [led.state == .one ? .oneComponent : .zeroComponent]
    }
}
