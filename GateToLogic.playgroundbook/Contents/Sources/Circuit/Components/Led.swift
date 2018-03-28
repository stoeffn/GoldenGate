//
//  Led.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

public struct Led : Codable {
    enum CodingKeys : String, CodingKey {
        case isLocked
    }
    
    public static let isActive = true

    public let orientations: Set<Orientation> = [.left]

    public var isLocked = false

    public private(set) var state = State.unknown

    public init() { }
}

extension Led : Composable {
    public subscript(_ orientation: Orientation) -> State {
        get { return .unknown }
        set {
            switch orientation {
            case .left: state = newValue
            default: return
            }
        }
    }

    public mutating func reset() {
        resetInputs()
        self.state = .unknown
    }
}
