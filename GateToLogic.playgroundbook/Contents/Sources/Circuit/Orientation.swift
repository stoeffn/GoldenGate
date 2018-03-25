//
//  Orientation.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

enum Orientation : String, Codable {
    case left, top, right, bottom

    var opposite: Orientation {
        switch self {
        case .left: return .right
        case .top: return .bottom
        case .right: return .left
        case .bottom: return .top
        }
    }

    var positionOffset: GridPoint {
        switch self {
        case .left: return GridPoint(x: -1, y: 0)
        case .top: return GridPoint(x: 0, y: -1)
        case .right: return GridPoint(x: 1, y: 0)
        case .bottom: return GridPoint(x: 0, y: 1)
        }
    }
}
