//
//  Circuit.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Circuit {
    // MARK: - Managing Components

    private(set) var components = [GridPoint: Composable]()

    var didAddComponentAt: ((GridPoint) -> Void)?

    var willRemoveComponentAt: ((GridPoint) -> Void)?

    mutating func add(_ component: Composable) {
        if components[component.position] != nil {
            willRemoveComponentAt?(component.position)
        }

        components[component.position] = component

        resetState()
        updatePassiveComponents()

        didAddComponentAt?(component.position)
    }

    mutating func removeComponent(at position: GridPoint) {
        guard components[position] != nil else { return }

        willRemoveComponentAt?(position)
        components[position] = nil

        resetState()
        updatePassiveComponents()
    }

    // MARK: - Managing State

    private mutating func resetState() {
        for position in components.keys {
            components[position]?.resetState()
        }
    }

    private mutating func updatePassiveComponents() {
        for position in components.keys {
            guard components[position]?.isActive ?? false else { continue }
            updateOutputsForComponent(at: position)
        }
    }

    private mutating func updateOutputsForComponent(at position: GridPoint) {
        guard let component = components[position] else { return }
        updateOutputs(at: .left, for: component)
        updateOutputs(at: .top, for: component)
        updateOutputs(at: .right, for: component)
        updateOutputs(at: .bottom, for: component)
    }

    private mutating func updateOutputs(at orientation: Orientation, for component: Composable) {
        let position = component.position + orientation.positionOffset
        if component.updateNeighbor(&components[position], at: orientation) {
            updateOutputsForComponent(at: position)
        }
    }

    mutating func tick() {
        for position in components.keys {
            components[position]?.tick()
        }

        resetState()
        updatePassiveComponents()
    }
}

extension Circuit : CustomStringConvertible {
    var description: String {
        let width = (components.keys.map { $0.x }.max() ?? 0) + 1
        let height = (components.keys.map { $0.y }.max() ?? 0) + 1

        return (0 ..< height).map { y in
            (0 ..< width).map { x in
                components[GridPoint(x: x, y: y)]?.description ?? " "
            }.joined()
        }.joined(separator: "\n")
    }
}
