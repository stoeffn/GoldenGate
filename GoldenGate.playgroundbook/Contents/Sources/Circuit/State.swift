//
//  State.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

public enum State : String, Codable {
    case unknown, zero, one
}

public extension State {
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

    static prefix func ! (state: State) -> State {
        guard state != .unknown else { return .unknown }
        return state == .one ? .zero : .one
    }
}
