//
//  State.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

enum State {
    case unknown, zero, one

    init(_ value: Bool) {
        self = value ? .one : .zero
    }

    var value: Bool {
        switch self {
        case .unknown, .zero: return false
        case .one: return true
        }
    }

    static func && (lhs: State, rhs: State) -> State {
        guard lhs != .unknown && rhs != .unknown else { return .unknown }
        return lhs == .one && rhs == .one ? .one : .zero
    }

    static func || (lhs: State, rhs: State) -> State {
        guard lhs != .unknown || rhs != .unknown else { return .unknown }
        return lhs == .one || rhs == .one ? .one : .zero
    }
}
