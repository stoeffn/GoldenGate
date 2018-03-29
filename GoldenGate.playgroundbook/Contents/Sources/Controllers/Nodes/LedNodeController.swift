//
//  LedNodeController.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class LedNodeController : NodeControlling {
    init(led: Led) {
        component = led
        update(with: led)
    }

    private(set) lazy var node: SCNNode = {
        guard
            let scene = SCNScene(named: componentsSceneName),
            let node = scene.rootNode.childNode(withName: "Led", recursively: true)
        else { fatalError() }
        node.position = SCNVector3()
        node.geometry?.materials = [.zeroLed]
        return node
    }()

    private lazy var socketNode: SCNNode = {
        guard let node = node.childNode(withName: "Led-Socket", recursively: true) else { fatalError() }
        node.geometry?.materials = [.zeroLed]
        return node
    }()

    private lazy var lightNode: SCNNode = {
        guard let node = node.childNode(withName: "Led-Light", recursively: true) else { fatalError() }
        node.light = SCNLight()
        node.light?.temperature = 128
        node.light?.intensity = 0
        return node
    }()

    private lazy var leftNode: SCNNode = {
        guard let node = node.childNode(withName: "Led-LeftWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    var component: Composable {
        didSet {
            guard let led = component as? Led, let oldLed = oldValue as? Led else { fatalError() }
            guard led != oldLed else { return }
            update(with: led)
        }
    }

    private func update(with led: Led) {
        node.geometry?.materials = [led.state == .one ? .oneLed : .zeroLed]
        socketNode.geometry?.materials = [led.state == .one ? .oneLed : .zeroLed]
        lightNode.light?.intensity = led.state == .one ? 1 : 0
        leftNode.geometry?.materials = [.material(for: led.state)]
    }
}