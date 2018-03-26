//
//  Composable.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import Foundation

public protocol Composable : Codable {
    var isActive: Bool { get }

    var orientations: Set<Orientation> { get }

    subscript(_ orientation: Orientation) -> State { get set }

    mutating func tick()

    mutating func trigger()

    mutating func resetInputs()

    func updateNeighbor(_ neighbor: inout Composable?, at orientation: Orientation) -> Bool
}

public extension Composable {
    subscript(_ orientation: Orientation) -> State {
        get { return .unknown }
        set { }
    }

    mutating func tick() { }

    mutating func trigger() { }

    mutating func resetInputs() {
        self[.left] = .unknown
        self[.top] = .unknown
        self[.right] = .unknown
        self[.bottom] = .unknown
    }

    func updateNeighbor(_ neighbor: inout Composable?, at orientation: Orientation) -> Bool {
        return false
    }
}

public extension Composable {
    func itemProvider(at position: GridPoint? = nil) -> NSItemProvider {
        let provider = NSItemProvider()
        provider.registerDataRepresentation(forTypeIdentifier: AnyPositionedComponent.identifier, visibility: .ownProcess) { completion in
            let anyComponent = AnyPositionedComponent(component: self, position: position ?? .zero)
            completion(try? JSONEncoder().encode(anyComponent), nil)
            return nil
        }
        return provider
    }
}
