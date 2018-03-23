//
//  Circuit.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct Circuit {
    private var components = [GridPoint: Component]()

    mutating func add(_ component: Component) {
        components[component.position] = component
        update()
    }

    private mutating func update() {
        for key in components.keys {
            guard let component = components[key] else { fatalError("Cannot enumerate components.") }
            component.updateNeighbor(&components[component.position - GridPoint(x: 1, y: 0)], at: .left)
            component.updateNeighbor(&components[component.position - GridPoint(x: 0, y: 1)], at: .top)
            component.updateNeighbor(&components[component.position + GridPoint(x: 1, y: 0)], at: .right)
            component.updateNeighbor(&components[component.position + GridPoint(x: 0, y: 1)], at: .bottom)
        }
    }

    mutating func tick() {
        for key in components.keys {
            components[key]?.tick()
        }
    }
}

extension Circuit : CustomStringConvertible {
    var description: String {
        let width = (components.keys.map { $0.x }.max() ?? 0) + 1
        let height = (components.keys.map { $0.y }.max() ?? 0) + 1
        return (0 ..< height).map { y in
            (0 ..< width).map { x in
                components[GridPoint(x: x, y: y)]?.description ?? " "
                }.joined()
            }.joined(separator: "\n")
    }
}
