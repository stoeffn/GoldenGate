//
//  Gate.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Gate {
    enum Operator {
        case and, or
    }

    let isActive = true

    var position: GridPoint

    let `operator`: Operator

    var left = State.unknown

    var top = State.unknown

    var bottom = State.unknown

    var state = State.unknown

    init(position: GridPoint = .zero, operator: Operator) {
        self.position = position
        self.operator = `operator`
    }
}

extension Gate : Composable {
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

    func updateNeighbor(_ neighbor: inout Composable?, at orientation: Orientation) -> Bool {
        guard orientation == .right, neighbor?[.left] != state else { return false }
        neighbor?[.left] = state
        return true
    }

    var inputs: Set<State> {
        return Set([left, top, bottom].filter { $0 != .unknown })
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
}
