//
//  NodeControlling.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

public protocol NodeControlling {
    var node: SCNNode { get }
}

let circuitSceneName = "CircuitAssets.scnassets/CircuitScene.scn"

let componentsSceneName = "CircuitAssets.scnassets/Components.scn"
