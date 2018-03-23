//
//  Orientation.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

enum Orientation {
    case left, top, right, bottom

    var opposite: Orientation {
        switch self {
        case .left: return .right
        case .top: return .bottom
        case .right: return .left
        case .bottom: return .top
        }
    }
}
