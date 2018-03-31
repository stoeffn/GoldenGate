//
//  NodeController.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

class NodeController {
    // MARK: - Life Cycle

    init?(component: Composable) {
        self.component = component
    }

    // MARK: - Nodes

    lazy var node: SCNNode = {
        guard
            let scene = SCNScene(named: NodeController.componentsSceneName),
            let node = scene.rootNode.childNode(withName: componentName, recursively: true)
        else { fatalError() }
        node.position = SCNVector3()
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    // MARK: - Managing Component

    var component: Composable

    var componentName: String {
        return ComponentEntity(component: component)?.rawValue.capitalized ?? "Ccomponent"
    }
}

// MARK: - Utilities

extension NodeController {
    static let circuitSceneName = "CircuitAssets.scnassets/CircuitScene.scn"

    static let componentPreviewSceneName = "CircuitAssets.scnassets/ComponentPreview.scn"

    static let componentsSceneName = "CircuitAssets.scnassets/Components.scn"

    static func `for`(_ component: Composable) -> NodeController? {
        switch component {
        case let constant as Constant:
            return ConstantNodeController(constant: constant)
        case let gate as Gate:
            return GateNodeController(gate: gate)
        case let inverter as Inverter:
            return InverterNodeController(inverter: inverter)
        case let led as Led:
            return LedNodeController(led: led)
        case let wire as Wire:
            return WireNodeController(wire: wire)
        default:
            return nil
        }
    }
}
