//
//  CircuitEditorViewController+Playground.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 29.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import PlaygroundSupport

extension CircuitEditorViewController : PlaygroundLiveViewMessageHandler {
    public func send(_ command: PlaygroundCommands) {
        send(.string(command.rawValue))
    }

    public func receive(_ message: PlaygroundValue) {
        guard case let .string(rawCommand) = message, let command = PlaygroundCommands(rawValue: rawCommand) else { return }

        switch command {
        case .runAssertions:
            assertCircuit()
        case .handleAssertionSuccess, .handleAssertionFailure:
            return
        }
    }
}
