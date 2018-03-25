//
//  Wire.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Wire : Codable {
    enum CodingKeys : String, CodingKey {
        case orientations
    }

    var isActive = false

    var orientations: Set<Orientation>

    private(set) var state = State.unknown

    init(orientations: Set<Orientation>) {
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
        guard orientations.contains(orientation) else { return false }
        let previousState = neighbor?[orientation.opposite]
        neighbor?[orientation.opposite] = state
        return previousState != neighbor?[orientation.opposite]
    }
}
