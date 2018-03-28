//
//  Gate.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Gate : Codable {
    enum CodingKeys : String, CodingKey {
        case isLocked, `operator`
    }

    enum Operator : String, Codable {
        case and, or
    }

    static let isActive = true

    let orientations: Set<Orientation> = [.left, .top, .right, .bottom]

    var isLocked = false

    let `operator`: Operator

    private var left = State.unknown

    private var top = State.unknown

    private var bottom = State.unknown

    private(set) var state = State.unknown

    init(operator: Operator) {
        self.operator = `operator`
    }
}

extension Gate : Composable {
    var inputs: Set<State> {
        return Set([left, top, bottom].filter { $0 != .unknown })
    }

    subscript(_ orientation: Orientation) -> State {
        get {
            switch orientation {
            case .left: return left
            case .top: return top
            case .right: return state
            case .bottom: return bottom
            }
        }
        set {
            switch orientation {
            case .left: left = newValue
            case .top: top = newValue
            case .right: return
            case .bottom: bottom = newValue
            }
        }
    }

    mutating func reset() {
        resetInputs()
        state = .unknown
    }

    mutating func tick() {
        guard !inputs.isEmpty else { return state = .unknown }

        switch `operator` {
        case .and:
            state = inputs.reduce(.one) { $0 && $1 }
        case .or:
            state = inputs.reduce(.zero) { $0 || $1 }
        }
    }

    func updated(neighbor: Composable, at orientation: Orientation) -> Composable {
        guard orientation == .right else { return neighbor }

        var neighbor = neighbor
        neighbor[orientation.opposite] = state
        return neighbor
    }
}
