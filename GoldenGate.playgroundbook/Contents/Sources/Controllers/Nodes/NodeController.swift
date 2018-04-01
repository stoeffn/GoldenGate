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

    // MARK: - Highlighting

    private lazy var highlightAction: SCNAction = {
        let action = SCNAction.group([
            .move(by: SCNVector3(x: 0, y: 0.25, z: 0), duration: 0.1),
            .fadeOpacity(to: 0.8, duration: 0.1)
        ])
        action.timingMode = .easeIn
        return action
    }()

    private lazy var unhighlightAction: SCNAction = {
        let action = SCNAction.group([
            .move(by: SCNVector3(x: 0, y: -0.25, z: 0), duration: 0.1),
            .fadeOpacity(to: 1, duration: 0.1)
        ])
        action.timingMode = .easeIn
        return action
    }()

    var isHighlighted = false {
        didSet {
            guard isHighlighted != oldValue else { return }
            node.runAction(isHighlighted ? highlightAction : unhighlightAction)
        }
    }

    // MARK: - Adding

    private lazy var addAction: SCNAction = {
        let action = SCNAction.move(by: SCNVector3(x: 0, y: 1, z: 0), duration: 0.2)
        action.timingMode = .easeOut
        return action
    }()

    func add(at position: GridPoint, animated: Bool = false) {
        move(to: position, animated: false)

        guard animated else { return }

        node.position = SCNVector3(x: node.position.x, y: -1, z: node.position.z)
        node.runAction(addAction)
    }

    // MARK: - Moving

    private func vector(for position: GridPoint) -> SCNVector3 {
        return SCNVector3(Float(position.x), 0, Float(position.y))
    }

    private func relativeVector(for position: GridPoint) -> SCNVector3 {
        return SCNVector3(Float(position.x) - Float(node.position.x), 0, Float(position.y) - Float(node.position.z))
    }

    private func action(forMovementTo position: GridPoint) -> SCNAction {
        let action = SCNAction.move(by: relativeVector(for: position), duration: 0.1)
        action.timingMode = .easeIn
        return action
    }

    private let movementActionKey = "movement"

    private(set) var animatingMovementTo: GridPoint?

    func move(to position: GridPoint, animated: Bool = false) {
        guard position != animatingMovementTo else { return }

        node.removeAction(forKey: movementActionKey)

        guard animated else { return node.position = vector(for: position) }

        animatingMovementTo = position
        node.runAction(action(forMovementTo: position), forKey: movementActionKey) {
            self.animatingMovementTo = nil
        }
    }

    // MARK: - Removing

    private lazy var removeAction: SCNAction = {
        let action = SCNAction.move(by: SCNVector3(x: 0, y: -2, z: 0), duration: 0.2)
        action.timingMode = .easeIn
        return action
    }()

    func remove(animated: Bool = false, completion: @escaping () -> Void) {
        guard animated else { return node.removeFromParentNode() }

        node.runAction(removeAction) {
            self.node.removeFromParentNode()
            completion()
        }
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
