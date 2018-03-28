//
//  Constant.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

public struct Constant : Codable {
    enum CodingKeys : String, CodingKey {
        case value, isLocked
    }

    public static let isActive = true

    public let orientations: Set<Orientation> = [.right]

    public var isLocked = false

    public var value: Bool

    public init(value: Bool) {
        self.value = value
    }
}

extension Constant : Composable {
    public var state: State {
        return State(value)
    }

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

    public func updated(neighbor: Composable, at orientation: Orientation) -> Composable {
        guard orientation == .right else { return neighbor }

        var neighbor = neighbor
        neighbor[orientation.opposite] = State(value)
        return neighbor
    }
}
