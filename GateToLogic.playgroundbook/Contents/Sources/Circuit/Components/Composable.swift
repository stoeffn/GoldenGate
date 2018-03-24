//
//  Composable.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

protocol Composable {
    var isActive: Bool { get }

    subscript(_ orientation: Orientation) -> State { get set }

    mutating func tick()

    mutating func resetInputs()

    func updateNeighbor(_ neighbor: inout Composable?, at orientation: Orientation) -> Bool
}

extension Composable {
    subscript(_ orientation: Orientation) -> State {
        get { return .unknown }
        set { }
    }

    mutating func tick() { }

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
