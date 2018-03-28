//
//  CircuitAssertion.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 27.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

/// Describes an assertion on a circuit with a defined initial state and expected component states after certain amounts of
/// ticks.
struct CircuitAssertion : Codable {
    /// Positions of components to trigger before running the simulation and assertions.
    let triggeredComponentPositions: Set<GridPoint>

    /// Expected states of components at position and point of time, i.e. ticks. Zero describes the initial state.
    let expectedStatesAtTicks: [Int: [GridPoint: State]]
}
