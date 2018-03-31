//
//  WireNodeController.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class WireNodeController : NodeControlling {
    init(wire: Wire) {
        component = wire
        update(with: wire)
    }

    private(set) lazy var node: SCNNode = {
        guard
            let scene = SCNScene(named: componentsSceneName),
            let node = scene.rootNode.childNode(withName: "Wire", recursively: true)
        else { fatalError() }
        node.position = SCNVector3()
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    private lazy var leftNode: SCNNode = {
        guard let node = node.childNode(withName: "Wire-Left", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    private lazy var topNode: SCNNode = {
        guard let node = node.childNode(withName: "Wire-Top", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    private lazy var rightNode: SCNNode = {
        guard let node = node.childNode(withName: "Wire-Right", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    private lazy var bottomNode: SCNNode = {
        guard let node = node.childNode(withName: "Wire-Bottom", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    private lazy var connectorNode: SCNNode = {
        guard let node = node.childNode(withName: "Wire-Connector", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        node.geometry?.tessellator = .default
        return node
    }()

    private lazy var bridgeNode: SCNNode = {
        guard let node = node.childNode(withName: "Wire-Bridge", recursively: true) else { fatalError() }
        node.geometry?.materials = [.unknownComponent]
        return node
    }()

    var component: Composable {
        didSet {
            guard let wire = component as? Wire, let oldWire = oldValue as? Wire else { fatalError() }
            guard wire != oldWire else { return }
            update(with: wire)
        }
    }

    private func update(with wire: Wire) {
        leftNode.isHidden = !wire.orientations.contains(.left)
        leftNode.geometry?.materials = [.material(for: wire[.left])]
        topNode.isHidden = wire.isBridging || !wire.orientations.contains(.top)
        topNode.geometry?.materials = [.material(for: wire[.top])]
        rightNode.isHidden = !wire.orientations.contains(.right)
        rightNode.geometry?.materials = [.material(for: wire[.right])]
        bottomNode.isHidden = wire.isBridging || !wire.orientations.contains(.bottom)
        bottomNode.geometry?.materials = [.material(for: wire[.bottom])]

        connectorNode.isHidden = wire.isBridging
            || wire.orientations == Orientation.horizontal
            || wire.orientations == Orientation.vertical
        connectorNode.geometry?.materials = [.material(for: wire.state)]
        bridgeNode.isHidden = !wire.isBridging
        bridgeNode.geometry?.materials = [.material(for: wire[.top])]
    }
}
