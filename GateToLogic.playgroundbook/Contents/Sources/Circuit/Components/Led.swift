//
//  Led.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Led : Codable {
    enum CodingKeys : CodingKey { }
    
    var isActive = true

    let orientations: Set<Orientation> = [.left]

    private(set) var value = false

    init() { }
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

    mutating func reset() {
        self.value = false
    }
}
