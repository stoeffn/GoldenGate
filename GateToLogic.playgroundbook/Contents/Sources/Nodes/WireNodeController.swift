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
        let geometry = SCNBox(width: 1.0, height: 0.5, length: 1.0, chamferRadius: 0)
        geometry.firstMaterial?.lightingModel = .physicallyBased
        return SCNNode(geometry: geometry)
    }()

    var wire: Wire {
        didSet {
            node.geometry?.firstMaterial?.diffuse.contents = wire.state == .one ? NSColor.green : NSColor.red
        }
    }
}
