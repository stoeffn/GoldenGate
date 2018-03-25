//
//  Gate.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Gate : Codable {
    enum CodingKeys : String, CodingKey {
        case `operator`
    }

    enum Operator : String, Codable {
        case and, or
    }

    let isActive = true

    let `operator`: Operator

    var left = State.unknown

    var top = State.unknown

    var bottom = State.unknown

    private var stateQueue: [State] = [.unknown, .unknown]

    var state: State {
        return stateQueue.first ?? .unknown
    }

    init(operator: Operator) {
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
        guard orientation == .right else { return false }
        let previousState = neighbor?[orientation.opposite]
        neighbor?[orientation.opposite] = state
        return previousState != neighbor?[orientation.opposite]
    }

    var inputs: Set<State> {
        return Set([left, top, bottom].filter { $0 != .unknown })
    }

    mutating func tick() {
        stateQueue.removeFirst()

        guard !inputs.isEmpty else { return stateQueue.append(.unknown) }

        switch `operator` {
        case .and:
            stateQueue.append(inputs.reduce(.one) { $0 && $1 })
        case .or:
            stateQueue.append(inputs.reduce(.zero) { $0 || $1 })
        }
    }
}
