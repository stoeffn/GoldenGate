//
//  Composable.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import Foundation

/// Something that acts a circuit component. Encapsulates state and update logic.
protocol Composable : Codable {
    /// Whether components of this type behave passively or actively.
    ///
    /// Active components like constants or gates manage state of their own and update their outputs—when needed—when `tick()`
    /// is invoked, which makes for a propagation delay. When updating the circuit, they are the starting point of state
    /// propagation. In other words, all passive components connected to their output as well as inputs of other active
    /// components will always be kept up-to-date.
    ///
    /// Pasive components, on the other hand, respond immediately to state changes around them, which is important for wires.
    static var isActive: Bool { get }

    /// Current state of this component.
    ///
    /// - Remark: This property must not change randomly as the circuit update algorithm bases its recursion depth on state
    ///           convergion.
    var state: State { get }

    /// Whether this component can be moved or removed.
    var isLocked: Bool { get set }

    /// Potentially available input and output orientations of this component.
    var orientations: Set<Orientation> { get }

    /// Input or output state at `orientation`. Must be idempotent.
    ///
    /// The default getter always returns `.unknown` and the default setter does nothing.
    subscript(_ orientation: Orientation) -> State { get set }

    /// Reset this component to a base state suitable for unit testing, e.g. by toggling switches off.
    ///
    /// The default implementation resets all inputs.
    mutating func reset()

    /// Reset all inputs.
    ///
    /// - Remark: Usually, you don't need to implement this method yourself as the default implementation uses the orientation
    ///           subscript.
    mutating func resetInputs()

    /// Update internal state based on inputs.
    ///
    /// The default implementation does nothing.
    mutating func update()

    /// Triggers this component, e.g. after a user tapping on it.
    ///
    /// The default implementation does nothing.
    mutating func trigger()

    /// Based on current state, update and return the neighbor at the orientation given by setting its inputs.
    ///
    /// The default implementation does nothing.
    ///
    /// - Postcondition: The component returned must be of the same type as the component given.
    func updated(neighbor: Composable, at orientation: Orientation) -> Composable
}

// MARK: - Default Implementations

extension Composable {
    subscript(_ orientation: Orientation) -> State {
        get { return .unknown }
        set { }
    }

    mutating func reset() {
        resetInputs()
    }

    mutating func resetInputs() {
        self[.left] = .unknown
        self[.top] = .unknown
        self[.right] = .unknown
        self[.bottom] = .unknown
    }

    mutating func update() { }

    mutating func trigger() { }

    func updated(neighbor: Composable, at orientation: Orientation) -> Composable {
        return neighbor
    }
}

// MARK: - Managing Item Providers

extension Composable {
    /// Returns an item provider that describes this component with its type as well as an optional position.
    func itemProvider(at position: GridPoint? = nil) -> NSItemProvider {
        let provider = NSItemProvider()
        provider.registerDataRepresentation(forTypeIdentifier: AnyPositionedComponent.identifier, visibility: .ownProcess) { completion in
            let anyComponent = AnyPositionedComponent(component: self, position: position)
            completion(try? JSONEncoder().encode(anyComponent), nil)
            return nil
        }
        return provider
    }
}

extension NSItemProvider {
    @discardableResult
    func loadComponent(completion: @escaping (Composable?, GridPoint?) -> Void) -> Progress {
        return loadDataRepresentation(forTypeIdentifier: AnyPositionedComponent.identifier) { (data, _) in
            guard
                let data = data,
                let positionedComponent = try? JSONDecoder().decode(AnyPositionedComponent.self, from: data)
            else { return }

            completion(positionedComponent.component, positionedComponent.position)
        }
    }
}
