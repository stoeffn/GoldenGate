//
//  GateNode.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class GateNodeController : NodeControlling {
    init(gate: Gate) {
        self.gate = gate
    }

    lazy var node: SCNNode = {
        let geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0)
        geometry.firstMaterial?.lightingModel = .physicallyBased
        return SCNNode(geometry: geometry)
    }()

    var gate: Gate {
        didSet {
            node.geometry?.firstMaterial?.diffuse.contents = gate.state == .one ? NSColor.red : NSColor.green
        }
    }
}
