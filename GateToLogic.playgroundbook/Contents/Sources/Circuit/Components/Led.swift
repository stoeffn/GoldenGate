//
//  Led.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Led {
    var isActive = true

    var position: GridPoint

    private(set) var value = false

    init(position: GridPoint = .zero) {
        self.position = position
    }
}

extension Led : Composable {
    subscript(_ orientation: Orientation) -> State {
        get { return .unknown }
        set {
            switch orientation {
            case .left: value = newValue.value
            default: return
            }
        }
    }

    mutating func resetState() {
        self.value = false
    }
}

extension Led : CustomStringConvertible {
    var description: String {
        return value ? "◉" : "◎"
    }
}
