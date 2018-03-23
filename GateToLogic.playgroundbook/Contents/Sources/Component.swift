//
//  Component.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

protocol Component : CustomStringConvertible {
    var position: GridPoint { get }

    subscript(_ orientation: Orientation) -> State { get set }

    mutating func tick()

    func updateNeighbor(_ neighbor: inout Component?, at orientation: Orientation)
}

extension Component {
    subscript(_ orientation: Orientation) -> State {
        get { return .unknown }
        set { }
    }

    mutating func tick() { }

    func updateNeighbor(_ neighbor: inout Component?, at orientation: Orientation) { }
}
