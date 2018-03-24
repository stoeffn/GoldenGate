//
//  Circuit.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Circuit {
    // MARK: - Managing Components

    private var components = [GridPoint: Composable]()

    var didAdd: ((Composable, GridPoint) -> Void)?

    var didUpdate: ((Composable, GridPoint) -> Void)?

    var didRemove: ((Composable, GridPoint) -> Void)?

    subscript(_ position: GridPoint) -> Composable? {
        get { return components[position] }
        set {
            guard let component = newValue else { return removeComponent(at: position) }
            set(component, at: position)
        }
    }

    private mutating func set(_ component: Composable, at position: GridPoint) {
        if let formerComponent = components[position] {
            didRemove?(formerComponent, position)
        }

        components[position] = component
        didAdd?(component, position)

        resetInputs()
        updatePassiveComponents()
    }

    private mutating func removeComponent(at position: GridPoint) {
        guard let component = components[position] else { return }

        didRemove?(component, position)
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

        updateOutputs(at: .left, for: component, at: position)
        updateOutputs(at: .top, for: component, at: position)
        updateOutputs(at: .right, for: component, at: position)
        updateOutputs(at: .bottom, for: component, at: position)
    }

    private mutating func updateOutputs(at orientation: Orientation, for component: Composable, at neighborPosition: GridPoint) {
        let neighborPosition = neighborPosition + orientation.positionOffset

        if component.updateNeighbor(&components[neighborPosition], at: orientation) {
            updateOutputsForComponent(at: neighborPosition)
        }

        if let neighbor = components[neighborPosition] {
            didUpdate?(neighbor, neighborPosition)
        }
    }

    mutating func tick() {
        for position in components.keys {
            components[position]?.tick()

            if let component = components[position] {
                didUpdate?(component, position)
            }
        }

        resetInputs()
        updatePassiveComponents()
    }
}
