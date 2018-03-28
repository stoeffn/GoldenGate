//
//  Wire.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Wire : Codable {
    enum CodingKeys : String, CodingKey {
        case orientations, isLocked, isBridging
    }

    static let isActive = false

    var orientations: Set<Orientation>

    var isLocked = false

    var isBridging = false

    private var horizontalState = State.unknown

    private var verticalState = State.unknown

    init(orientations: Set<Orientation>) {
        self.orientations = orientations
    }
}

extension Wire : Equatable {
    static func == (lhs: Wire, rhs: Wire) -> Bool {
        return lhs.orientations == rhs.orientations
            && lhs.isLocked == rhs.isLocked
            && lhs.isBridging == rhs.isBridging
            && lhs.horizontalState == rhs.horizontalState
            && lhs.verticalState == rhs.verticalState
    }
}

extension Wire : Composable {
    var state: State {
        return horizontalState || verticalState
    }

    subscript(_ orientation: Orientation) -> State {
        get {
            guard orientations.contains(orientation) else { return .unknown }
            switch orientation {
            case .left, .right: return isBridging ? horizontalState : state
            case .top, .bottom: return isBridging ? verticalState : state
            }
        }
        set {
            guard orientations.contains(orientation) else { return }
            switch orientation {
            case .left, .right: horizontalState = horizontalState || newValue
            case .top, .bottom: verticalState = verticalState || newValue
            }
        }
    }

    mutating func resetInputs() {
        horizontalState = .unknown
        verticalState = .unknown
    }

    mutating func trigger() {
        guard orientations != Orientation.all else { return isBridging = !isBridging }
        orientations = Set(orientations.map { $0.next })
    }

    func updated(neighbor: Composable, at orientation: Orientation) -> Composable {
        guard orientations.contains(orientation) else { return neighbor }

        var neighbor = neighbor
        switch orientation {
        case .left, .right: neighbor[orientation.opposite] = isBridging ? horizontalState : state
        case .top, .bottom: neighbor[orientation.opposite] = isBridging ? verticalState : state
        }
        return neighbor
    }
}
