//
//  WireNode.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class WireNodeController : NodeControlling {
    init(wire: Wire) {
        self.wire = wire
    }

    lazy var node: SCNNode = {
        guard
            let scene = SCNScene(named: componentsSceneName),
            let node = scene.rootNode.childNode(withName: "Wire", recursively: true)
        else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    lazy var leftRightNode: SCNNode = {
        guard let node = node.childNode(withName: "Wire-LeftRight", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    lazy var topBottomNode: SCNNode = {
        guard let node = node.childNode(withName: "Wire-TopBottom", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    var wire: Wire {
        didSet {
            leftRightNode.geometry?.materials = [.material(for: wire.state)]
            topBottomNode.geometry?.materials = [.material(for: wire.state)]
        }
    }
}
