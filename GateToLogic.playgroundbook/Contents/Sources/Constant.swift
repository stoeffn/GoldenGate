//
//  Constant.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Constant {
    var position: GridPoint

    let value: Bool

    init(position: GridPoint, value: Bool) {
        self.position = position
        self.value = value
    }
}

extension Constant: Component {
    subscript(_ orientation: Orientation) -> State {
        get {
            switch orientation {
            case .right: return State(value)
            default: return .unknown
            }
        }
        set { }
    }

    func updateNeighbor(_ neighbor: inout Component?, at orientation: Orientation) {
        switch orientation {
        case .right: neighbor?[.left] = State(value)
        default: return
        }
    }
}

extension Constant : CustomStringConvertible {
    var description: String {
        return value ? "1" : "0"
    }
}
