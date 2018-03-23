//
//  Wire.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Wire {
    var position: GridPoint

    var orientations: Set<Orientation>

    private(set) var state = State.unknown

    init(position: GridPoint, orientations: Set<Orientation>) {
        self.position = position
        self.orientations = orientations
    }
}

extension Wire : Component {
    subscript(_ orientation: Orientation) -> State {
        get { return state }
        set { state = newValue }
    }

    func updateNeighbor(_ neighbor: inout Component?, at orientation: Orientation) {
        if orientations.contains(orientation) {
            neighbor?[orientation.opposite] = state
        }
    }
}

extension Wire : CustomStringConvertible {
    var description: String {
        switch orientations {
        case []: return "・"
        case [.left, .right]: return "—"
        case [.top, .bottom]: return "|"
        default: return "+"
        }
    }
}
