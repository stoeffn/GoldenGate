//
//  Led.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

/// Visualizes state as a light.
struct Led : Codable {
    enum CodingKeys : String, CodingKey {
        case isLocked
    }
    
    static let isActive = false

    let orientations: Set<Orientation> = [.left]

    var isLocked = false

    private(set) var state = State.unknown

    init() { }
}

// MARK: - Comparing

extension Led : Equatable {
    static func == (lhs: Led, rhs: Led) -> Bool {
        return lhs.isLocked == rhs.isLocked
            && lhs.state == rhs.state
    }
}

// MARK: - Composing

extension Led : Composable {
    subscript(_ orientation: Orientation) -> State {
        get { return .unknown }
        set {
            switch orientation {
            case .left: state = newValue
            default: return
            }
        }
    }
}
