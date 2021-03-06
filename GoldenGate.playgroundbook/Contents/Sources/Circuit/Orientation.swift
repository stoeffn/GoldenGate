//
//  Orientation.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

public enum Orientation : String, Codable {
    case left, top, right, bottom
}

// MARK: - Utilities

public extension Orientation {
    static let all: Set<Orientation> = [.left, .top, .right, .bottom]

    static let horizontal: Set<Orientation> = [.left, .right]

    static let vertical: Set<Orientation> = [.top, .bottom]

    /// Next clockwise orientation.
    var next: Orientation {
        switch self {
        case .left: return .top
        case .top: return .right
        case .right: return .bottom
        case .bottom: return .left
        }
    }

    var opposite: Orientation {
        switch self {
        case .left: return .right
        case .top: return .bottom
        case .right: return .left
        case .bottom: return .top
        }
    }

    /// Grid offset by this orienation's direction by one unit.
    var positionOffset: GridPoint {
        switch self {
        case .left: return GridPoint(x: -1, y: 0)
        case .top: return GridPoint(x: 0, y: -1)
        case .right: return GridPoint(x: 1, y: 0)
        case .bottom: return GridPoint(x: 0, y: 1)
        }
    }
}
