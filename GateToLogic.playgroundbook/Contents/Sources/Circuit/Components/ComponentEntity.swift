//
//  ComponentEntity.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 25.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

enum ComponentEntity : String, Codable {
    case constant, gate, led, wire

    init?(component: Composable) {
        switch component {
        case is Constant: self = .constant
        case is Gate: self = .gate
        case is Led: self = .led
        case is Wire: self = .wire
        default: return nil
        }
    }
}