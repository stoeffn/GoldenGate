//
//  Constant.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

public struct Constant : Codable {
    enum CodingKeys : String, CodingKey {
        case value
    }

    public let isActive = true

    public let orientations: Set<Orientation> = [.right]

    public var value: Bool

    public init(value: Bool) {
        self.value = value
    }
}

extension Constant : Composable {
    public subscript(_ orientation: Orientation) -> State {
        get {
            switch orientation {
            case .right: return State(value)
            default: return .unknown
            }
        }
        set { }
    }

    public mutating func trigger() {
        self.value = !self.value
    }

    public func updateNeighbor(_ neighbor: inout Composable?, at orientation: Orientation) -> Bool {
        guard orientation == .right else { return false }
        let previousState = neighbor?[orientation.opposite]
        neighbor?[orientation.opposite] = State(value)
        return previousState != neighbor?[orientation.opposite]
    }
}
