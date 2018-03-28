//
//  Composable.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import Foundation

protocol Composable : Codable {
    static var isActive: Bool { get }

    var state: State { get }

    var isLocked: Bool { get set }

    var orientations: Set<Orientation> { get }

    subscript(_ orientation: Orientation) -> State { get set }

    mutating func reset()

    mutating func resetInputs()

    mutating func tick()

    mutating func trigger()

    func updated(neighbor: Composable, at orientation: Orientation) -> Composable
}

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

    mutating func tick() { }

    mutating func trigger() { }

    func updated(neighbor: Composable, at orientation: Orientation) -> Composable {
        return neighbor
    }
}

extension Composable {
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
