//
//  LedNodeController.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class LedNodeController : NodeController {
    // MARK: - Life Cycle

    init?(led: Led) {
        super.init(component: led)
        update(with: led)
    }

    // MARK: - Nodes

    private lazy var socketNode: SCNNode = {
        guard let node = node.childNode(withName: "\(componentName)-Socket", recursively: true) else { fatalError() }
        node.geometry?.materials = [.zeroLed]
        return node
    }()

    private lazy var lightNode: SCNNode = {
        guard let node = node.childNode(withName: "\(componentName)-Light", recursively: true) else { fatalError() }
        node.light = SCNLight()
        node.light?.temperature = 128
        node.light?.intensity = 0.1
        return node
    }()

    private lazy var leftNode: SCNNode = {
        guard let node = node.childNode(withName: "\(componentName)-LeftWire", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    // MARK: - Managing Component

    override var component: Composable {
        didSet {
            guard let led = component as? Led, let oldLed = oldValue as? Led else { fatalError() }
            guard led != oldLed else { return }
            update(with: led)
        }
    }

    private func update(with led: Led) {
        node.geometry?.materials = [led.state == .one ? .oneLed : .zeroLed]
        node.castsShadow = led.state != .one
        socketNode.geometry?.materials = [led.state == .one ? .oneLed : .zeroLed]
        socketNode.castsShadow = led.state != .one
        lightNode.light?.intensity = led.state == .one ? 1.5 : 0
        leftNode.geometry?.materials = [.material(for: led.state)]
    }
}
