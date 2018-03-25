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

    var wire: Wire {
        didSet {
            node.geometry?.materials = [.material(for: wire.state)]
        }
    }
}
