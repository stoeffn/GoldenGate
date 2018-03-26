//
//  NodeControlling.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

public protocol NodeControlling {
    var node: SCNNode { get }

    var component: Composable { get set }
}

let circuitSceneName = "CircuitAssets.scnassets/CircuitScene.scn"

let componentPreviewSceneName = "CircuitAssets.scnassets/ComponentPreview.scn"

let componentsSceneName = "CircuitAssets.scnassets/Components.scn"

func nodeController(for component: Composable) -> NodeControlling {
    switch component {
    case let constant as Constant:
        return ConstantNodeController(constant: constant)
    case let gate as Gate:
        return GateNodeController(gate: gate)
    case let led as Led:
        return LedNodeController(led: led)
    case let wire as Wire:
        return WireNodeController(wire: wire)
    default:
        fatalError("Cannot create node controller for component \(component).")
    }
}
