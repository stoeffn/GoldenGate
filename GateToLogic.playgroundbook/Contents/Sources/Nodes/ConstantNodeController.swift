//
//  ConstantNode.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class ConstantNodeController : NodeControlling {
    init(constant: Constant) {
        self.constant = constant
    }

    lazy var node: SCNNode = {
        let geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0)
        geometry.firstMaterial?.lightingModel = .physicallyBased
        return SCNNode(geometry: geometry)
    }()

    var constant: Constant {
        didSet {
            node.geometry?.firstMaterial?.diffuse.contents = constant.value ? NSColor.red : NSColor.green
        }
    }
}
