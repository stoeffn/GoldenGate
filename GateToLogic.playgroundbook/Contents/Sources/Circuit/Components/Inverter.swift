//
//  Inverter.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 28.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

public struct Inverter : Codable {
    enum CodingKeys : String, CodingKey {
        case isLocked
    }

    public static let isActive = true

    public let orientations: Set<Orientation> = [.left, .right]

    public var isLocked = false

    private var input = State.unknown

    public private(set) var state = State.unknown

    public init() { }
}

extension Inverter : Composable {
    public subscript(_ orientation: Orientation) -> State {
        get {
            switch orientation {
            case .left: return input
            case .right: return state
            default: return .unknown
            }
        }
        set {
            switch orientation {
            case .left: input = newValue
            default: return
            }
        }
    }

    public mutating func reset() {
        resetInputs()
        state = .unknown
    }

    public mutating func tick() {
        state = !input
    }

    public func updateNeighbor(_ neighbor: inout Composable?, at orientation: Orientation) -> Bool {
        guard orientation == .right else { return false }
        let previousState = neighbor?[orientation.opposite]
        neighbor?[orientation.opposite] = state
        return previousState != neighbor?[orientation.opposite]
    }
}
