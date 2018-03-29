//
//  PlaygroundCommands.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 29.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

public enum PlaygroundCommands : String {
    case runAssertions

    case handleAssertionSuccess

    case handleAssertionFailure
}

public extension PlaygroundCommands {
    static func fromAssertionResult(_ isSuccess: Bool) -> PlaygroundCommands {
        return isSuccess ? .handleAssertionSuccess : .handleAssertionFailure
    }
}
