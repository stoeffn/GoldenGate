//
//  Constant.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Constant {
    let isActive = true

    var value: Bool

    init(value: Bool) {
        self.value = value
    }
}

extension Constant : Composable {
    subscript(_ orientation: Orientation) -> State {
        get {
            switch orientation {
            case .right: return State(value)
            default: return .unknown
            }
        }
        set { }
    }

    func updateNeighbor(_ neighbor: inout Composable?, at orientation: Orientation) -> Bool {
        guard orientation == .right, neighbor?[.left] != State(value) else { return false }
        neighbor?[.left] = State(value)
        return true
    }
}
