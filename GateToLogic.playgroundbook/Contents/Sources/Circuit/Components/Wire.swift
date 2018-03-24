//
//  Wire.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Wire {
    var isActive = false

    var position: GridPoint

    var orientations: Set<Orientation>

    private(set) var state = State.unknown

    init(position: GridPoint = .zero, orientations: Set<Orientation>) {
        self.position = position
        self.orientations = orientations
    }
}

extension Wire : Composable {
    subscript(_ orientation: Orientation) -> State {
        get { return orientations.contains(orientation) ? state : .unknown }
        set { state = orientations.contains(orientation) ? state || newValue : state }
    }

    mutating func resetInputs() {
        state = .unknown
    }

    func updateNeighbor(_ neighbor: inout Composable?, at orientation: Orientation) -> Bool {
        guard orientations.contains(orientation), neighbor?[orientation.opposite] != state else { return false }
        neighbor?[orientation.opposite] = state
        return true
    }
}
