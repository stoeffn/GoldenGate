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

    var didAdd: ((Composable) -> Void)?

    var didUpdate: ((Composable) -> Void)?

    var didRemove: ((Composable) -> Void)?

    mutating func add(_ component: Composable) {
        if let formerComponent = components[component.position] {
            didRemove?(formerComponent)
        }

        components[component.position] = component
        didAdd?(component)

        resetInputs()
        updatePassiveComponents()
    }

    mutating func removeComponent(at position: GridPoint) {
        guard let component = components[position] else { return }

        didRemove?(component)
        components[position] = nil

        resetInputs()
        updatePassiveComponents()
    }

    // MARK: - Managing State

    private mutating func resetInputs() {
        for position in components.keys {
            components[position]?.resetInputs()
        }
    }

    private mutating func updatePassiveComponents() {
        for position in components.keys {
            guard let component = components[position], component.isActive else { continue }
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

        if let neighbor = components[position] {
            didUpdate?(neighbor)
        }
    }

    mutating func tick() {
        for position in components.keys {
            components[position]?.tick()

            if let component = components[position] {
                didUpdate?(component)
            }
        }

        resetInputs()
        updatePassiveComponents()
    }
}
