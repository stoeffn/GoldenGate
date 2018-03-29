//
//  GridPoint.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import CoreGraphics

public struct GridPoint : Codable {
    public let x: Int

    public let y: Int

    public static let zero = GridPoint(x: 0, y: 0)
}

public extension GridPoint {
    init(point: CGPoint) {
        self.x = Int(round(point.x))
        self.y = Int(round(point.y))
    }

    static func + (lhs: GridPoint, rhs: GridPoint) -> GridPoint {
        return GridPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: GridPoint, rhs: GridPoint) -> GridPoint {
        return lhs + -rhs
    }

    static prefix func - (point: GridPoint) -> GridPoint {
        return GridPoint(x: -point.x, y: -point.y)
    }
}

extension GridPoint : CustomStringConvertible {
    public var description: String {
        return "(x: \(x), y: \(y))"
    }
}

extension GridPoint : Hashable {
    public var hashValue: Int {
        return x.hashValue ^ y.hashValue &* 16777619
    }

    public static func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
