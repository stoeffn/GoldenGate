//
//  Led.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

public struct Led : Codable {
    enum CodingKeys : CodingKey { }
    
    public var isActive = true

    public let orientations: Set<Orientation> = [.left]

    private(set) var value = false

    public init() { }
}

extension Led : Composable {
    public subscript(_ orientation: Orientation) -> State {
        get { return .unknown }
        set {
            switch orientation {
            case .left: value = newValue.value
            default: return
            }
        }
    }

    public mutating func reset() {
        self.value = false
    }
}
