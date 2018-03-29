//
//  CircuitEditorViewController+Playground.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 29.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import PlaygroundSupport

extension CircuitEditorViewController : PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        assertCircuit()
    }
}
