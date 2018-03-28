//
//  Wire.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Wire : Codable {
    enum CodingKeys : String, CodingKey {
        case orientations, isLocked
    }

    static let isActive = false

    var orientations: Set<Orientation>

    var isLocked = false

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

    mutating func trigger() {
        orientations = Set(orientations.map { $0.next })
    }

    func updated(neighbor: Composable, at orientation: Orientation) -> Composable {
        guard orientations.contains(orientation) else { return neighbor }

        var neighbor = neighbor
        neighbor[orientation.opposite] = state
        return neighbor
    }
}
