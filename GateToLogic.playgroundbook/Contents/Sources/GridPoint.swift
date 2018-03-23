//
//  GridPoint.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct GridPoint {
    let x: Int

    let y: Int

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
    var description: String {
        return "(x: \(x), y: \(y))"
    }
}

extension GridPoint : Hashable {
    var hashValue: Int {
        return x.hashValue ^ y.hashValue &* 16777619
    }

    static func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
