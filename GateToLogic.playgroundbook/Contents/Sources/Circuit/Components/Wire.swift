//
//  Wire.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

public struct Wire : Codable {
    enum CodingKeys : String, CodingKey {
        case orientations
    }

    public var isActive = false

    public var orientations: Set<Orientation>

    private(set) var state = State.unknown

    public init(orientations: Set<Orientation>) {
        self.orientations = orientations
    }
}

extension Wire : Composable {
    public subscript(_ orientation: Orientation) -> State {
        get { return orientations.contains(orientation) ? state : .unknown }
        set { state = orientations.contains(orientation) ? state || newValue : state }
    }

    public mutating func resetInputs() {
        state = .unknown
    }

    public func updateNeighbor(_ neighbor: inout Composable?, at orientation: Orientation) -> Bool {
        guard orientations.contains(orientation) else { return false }
        let previousState = neighbor?[orientation.opposite]
        neighbor?[orientation.opposite] = state
        return previousState != neighbor?[orientation.opposite]
    }
}
