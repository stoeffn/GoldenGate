//
//  Constant.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

/// Defines a constant that can be used as a switch.
struct Constant : Codable {
    enum CodingKeys : String, CodingKey {
        case isLocked, isOn
    }

    static let isActive = true

    let orientations: Set<Orientation> = [.right]

    var isLocked = false

    var isOn: Bool

    init(isOn: Bool) {
        self.isOn = isOn
    }
}

// MARK: - Comparing

extension Constant : Equatable {
    static func == (lhs: Constant, rhs: Constant) -> Bool {
        return lhs.isLocked == rhs.isLocked
            && lhs.isOn == rhs.isOn
    }
}

// MARK: - Composing

extension Constant : Composable {
    var state: State {
        return State(isOn)
    }

    subscript(_ orientation: Orientation) -> State {
        get {
            switch orientation {
            case .right: return State(isOn)
            default: return .unknown
            }
        }
        set { }
    }

    /// Sets `isOn` to `false` if locked.
    mutating func reset() {
        guard isLocked else { return }
        isOn = false
    }

    /// Toggles `isOn`.
    mutating func trigger() {
        self.isOn = !self.isOn
    }

    func updated(neighbor: Composable, at orientation: Orientation) -> Composable {
        guard orientation == .right else { return neighbor }

        var neighbor = neighbor
        neighbor[orientation.opposite] = State(isOn)
        return neighbor
    }
}
