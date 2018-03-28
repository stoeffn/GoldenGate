//
//  Wire.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

public struct Wire : Codable {
    enum CodingKeys : String, CodingKey {
        case orientations, isLocked
    }

    public static let isActive = false

    public var orientations: Set<Orientation>

    public var isLocked = false

    public private(set) var state = State.unknown

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

    public mutating func trigger() {
        orientations = Set(orientations.map { $0.next })
    }

    public func updated(neighbor: Composable, at orientation: Orientation) -> Composable {
        guard orientations.contains(orientation) else { return neighbor }

        var neighbor = neighbor
        neighbor[orientation.opposite] = state
        return neighbor
    }
}
