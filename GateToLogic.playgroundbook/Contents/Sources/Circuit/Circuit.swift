//
//  Circuit.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import Foundation

public struct Circuit {

    // MARK: - Life Cycle

    public init() {
        components = [:]
    }

    public static func named(_ name: String) -> Circuit? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "logic") else { return nil }
        return try? JSONDecoder().decode(Circuit.self, from: Data(contentsOf: url))
    }

    // MARK: - Managing Components

    private var components: [GridPoint: Composable]

    public var didAdd: ((Composable, GridPoint) -> Void)?

    public var didUpdate: ((Composable, GridPoint) -> Void)?

    public var didRemove: ((Composable, GridPoint) -> Void)?

    public subscript(_ position: GridPoint) -> Composable? {
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

    public var positionedComponents: [(Composable, at: GridPoint)] {
        return components.map { ($0.value, at: $0.key) }
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

    public mutating func tick() {
        for position in components.keys {
            components[position]?.tick()

            if let component = components[position] {
                didUpdate?(component, position)
            }
        }

        resetInputs()
        updatePassiveComponents()
    }

    // MARK: - Helpers

    public func suggestedOrientations(forWireAt positon: GridPoint) -> Set<Orientation> {
        let orientations: [Orientation] = [
            components[positon + Orientation.left.positionOffset]?.orientations.contains(.right) ?? false ? .left : nil,
            components[positon + Orientation.top.positionOffset]?.orientations.contains(.bottom) ?? false ? .top : nil,
            components[positon + Orientation.right.positionOffset]?.orientations.contains(.left) ?? false ? .right : nil,
            components[positon + Orientation.bottom.positionOffset]?.orientations.contains(.top) ?? false ? .bottom : nil
        ].flatMap { $0 }
        guard !orientations.isEmpty else { return [.left, .right] }
        guard let orientation = orientations.first, orientations.count == 1 else { return Set(orientations) }
        return [orientation, orientation.opposite]
    }
}

// MARK: - Coding

extension Circuit : Codable {
    enum CodingKeys : String, CodingKey {
        case components
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let positionedComponents = try container.decode([AnyPositionedComponent].self, forKey: .components)
        components = Dictionary(uniqueKeysWithValues: positionedComponents.map { (key: $0.position, value: $0.component) })
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let positionedComponents = components.flatMap { AnyPositionedComponent(component: $0.value, position: $0.key) }
        try positionedComponents.encode(to: container.superEncoder(forKey: .components))
    }
}
