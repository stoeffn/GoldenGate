//
//  Constant.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Constant : Codable {
    enum CodingKeys : String, CodingKey {
        case value, isLocked
    }

    static let isActive = true

    let orientations: Set<Orientation> = [.right]

    var isLocked = false

    var value: Bool

    init(value: Bool) {
        self.value = value
    }
}

extension Constant : Equatable {
    static func == (lhs: Constant, rhs: Constant) -> Bool {
        return lhs.isLocked == rhs.isLocked
            && lhs.value == rhs.value
    }
}

extension Constant : Composable {
    var state: State {
        return State(value)
    }

    subscript(_ orientation: Orientation) -> State {
        get {
            switch orientation {
            case .right: return State(value)
            default: return .unknown
            }
        }
        set { }
    }

    mutating func reset() {
        value = false
    }

    mutating func trigger() {
        self.value = !self.value
    }

    func updated(neighbor: Composable, at orientation: Orientation) -> Composable {
        guard orientation == .right else { return neighbor }

        var neighbor = neighbor
        neighbor[orientation.opposite] = State(value)
        return neighbor
    }
}
