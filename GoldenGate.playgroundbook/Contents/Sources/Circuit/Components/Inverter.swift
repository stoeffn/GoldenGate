//
//  Inverter.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 28.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

/// Inverts its input.
struct Inverter : Codable {
    enum CodingKeys : String, CodingKey {
        case isLocked
    }

    static let isActive = true

    let orientations: Set<Orientation> = [.left, .right]

    var isLocked = false

    private var input = State.unknown

    private(set) var state = State.unknown

    init() { }
}

// MARK: - Comparing

extension Inverter : Equatable {
    static func == (lhs: Inverter, rhs: Inverter) -> Bool {
        return lhs.isLocked == rhs.isLocked
            && lhs.input == rhs.input
            && lhs.state == rhs.state
    }
}

// MARK: - Composing

extension Inverter : Composable {
    subscript(_ orientation: Orientation) -> State {
        get {
            switch orientation {
            case .left: return input
            case .right: return state
            default: return .unknown
            }
        }
        set {
            switch orientation {
            case .left: input = newValue
            default: return
            }
        }
    }

    mutating func reset() {
        resetInputs()
        state = .unknown
    }

    mutating func update() {
        state = !input
    }

    func updated(neighbor: Composable, at orientation: Orientation) -> Composable {
        guard orientation == .right else { return neighbor }

        var neighbor = neighbor
        neighbor[orientation.opposite] = state
        return neighbor
    }
}
