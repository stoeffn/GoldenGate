//
//  Circuit.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import Foundation

/// Circuit that manages components and their positions in a grid as well as updating and asserting state.
public struct Circuit {

    // MARK: - Life Cycle

    /// Creates an empty circuit.
    public init() { }

    /// Tries to load a circuit from "`name`.circuit".
    public static func named(_ name: String) -> Circuit? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "circuit") else { return nil }
        return try? JSONDecoder().decode(Circuit.self, from: Data(contentsOf: url))
    }

    // MARK: - Managing Components

    private var components = [GridPoint: Composable]()

    /// Invoked after a component was added.
    var didAdd: ((Composable, GridPoint) -> Void)?

    /// Invoked after a component was updated. If the component's type has changed, `didRemove` and `didAdd` are invoked
    /// instead.
    var didUpdate: ((Composable, GridPoint) -> Void)?

    /// Invoked after a component was removed from the circuit.
    var didRemove: ((Composable, GridPoint) -> Void)?

    /// Gets or sets a component at the given position and triggers corresponding callbacks and updates to passive components.
    /// There can only be one component at a position.
    ///
    /// - Remark: Locked components cannot be removed or replaced.
    subscript(_ position: GridPoint) -> Composable? {
        get { return components[position] }
        set {
            guard let component = newValue else { return removeComponent(at: position) }
            set(component, at: position)
        }
    }

    private mutating func set(_ component: Composable, at position: GridPoint) {
        defer {
            resetInputs()
            updatePassiveComponents()
        }

        guard let oldComponent = components[position] else {
            components[position] = component
            didAdd?(component, position)
            return
        }

        guard !oldComponent.isLocked || type(of: component) == type(of: oldComponent) else { return }

        components[position] = component

        if type(of: component) == type(of: oldComponent) {
            didUpdate?(component, position)
        } else {
            didRemove?(oldComponent, position)
        }
    }

    private mutating func removeComponent(at position: GridPoint) {
        guard let component = components[position], !component.isLocked else { return }

        components[position] = nil
        didRemove?(component, position)

        resetInputs()
        updatePassiveComponents()
    }

    /// All components along with their position.
    var positionedComponents: [(Composable, at: GridPoint)] {
        return components.map { ($0.value, at: $0.key) }
    }

    // MARK: - Managing State

    private mutating func reset() {
        for position in components.keys {
            components[position]?.reset()
        }
    }

    private mutating func resetInputs() {
        for position in components.keys {
            components[position]?.resetInputs()
        }
    }

    private mutating func updatePassiveComponents() {
        for position in components.keys {
            guard let component = components[position], type(of: component).isActive else { continue }
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
        guard let oldNeighbor = components[neighborPosition] else { return }

        let neighbor = component.updated(neighbor: oldNeighbor, at: orientation)
        components[neighborPosition] = neighbor
        didUpdate?(neighbor, neighborPosition)

        // TODO: Implement Equatable conformance instead of abusing this type cast…
        let isNeighborBridging = (neighbor as? Wire)?.isBridging ?? false
        guard neighbor.state != oldNeighbor.state || isNeighborBridging else { return }
        updateOutputsForComponent(at: neighborPosition)
    }

    /// Updates all active components and connected passive components.
    mutating func update() {
        for position in components.keys {
            components[position]?.update()

            guard let component = components[position] else { return }
            didUpdate?(component, position)
        }

        resetInputs()
        updatePassiveComponents()
    }

    // MARK: - Asserting State

    /// Assertions applied to this circuit when accessing `meetsAssertions`.
    var assertions = [CircuitAssertion]()

    /// Whether this circuit meets all associated `assertions`.
    var meetsAssertions: Bool {
        return assertions
            .map(self.meets)
            .reduce(true) { $0 && $1 }
    }

    /// Whether this circuit meets the assertion given.
    ///
    /// Asserting resets the circuit, triggers specified components, simulates it, and asserts states at specific positions and
    /// specific points of time.
    ///
    /// - Postcondition: This method does not modify this circuit as it uses a copy.
    func meets(assertion: CircuitAssertion) -> Bool {
        var circuit = self
        circuit.didAdd = nil
        circuit.didUpdate = nil
        circuit.didRemove = nil
        circuit.reset()
        circuit.updatePassiveComponents()

        for position in assertion.triggeredComponentPositions {
            circuit[position]?.trigger()
        }

        let tickCount = assertion.expectedStatesAtTicks.keys.max() ?? 0
        for tick in 0 ... tickCount {
            guard let expectedStates = assertion.expectedStatesAtTicks[tick] else {
                circuit.update()
                continue
            }

            let failedAssertions = expectedStates.filter { circuit[$0.key]?.state != $0.value }
            guard failedAssertions.isEmpty else { return false }

            circuit.update()
        }

        return true
    }

    // MARK: - Helpers

    func suggestedOrientations(forWireAt positon: GridPoint) -> Set<Orientation> {
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
        case components, assertions
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let positionedComponents = try container.decode([AnyPositionedComponent].self, forKey: .components)
        components = Dictionary(uniqueKeysWithValues: positionedComponents.map { (key: $0.position ?? .zero, value: $0.component) })
        assertions = try container.decode([CircuitAssertion].self, forKey: .assertions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let positionedComponents = components.flatMap { AnyPositionedComponent(component: $0.value, position: $0.key) }
        try positionedComponents.encode(to: container.superEncoder(forKey: .components))
        try assertions.encode(to: container.superEncoder(forKey: .assertions))
    }
}
