//
//  Materials.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 25.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

extension SCNMaterial {
    static var component: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = NSColor.white
        material.metalness.intensity = 0
        material.diffuse.contents = NSColor.white
        material.diffuse.intensity = 1
        material.roughness.contents = NSColor.white
        material.roughness.intensity = 0.25
        return material
    }()

    static var unknownComponent: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = NSColor.white
        material.metalness.intensity = 0.5
        material.diffuse.contents = NSColor.white
        material.diffuse.intensity = 0.5
        material.roughness.contents = NSColor.white
        material.roughness.intensity = 0.25
        return material
    }()

    static var zeroComponent: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = NSColor.red
        material.metalness.intensity = 0.5
        material.diffuse.contents = NSColor.red
        material.diffuse.intensity = 0.5
        material.roughness.contents = NSColor.red
        material.roughness.intensity = 0.25
        return material
    }()

    static var oneComponent: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = NSColor.green
        material.metalness.intensity = 0.5
        material.diffuse.contents = NSColor.green
        material.diffuse.intensity = 0.5
        material.roughness.contents = NSColor.green
        material.roughness.intensity = 0.25
        return material
    }()

    static var zeroLed: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = NSColor.orange
        material.metalness.intensity = 0.5
        material.diffuse.contents = NSColor.orange
        material.diffuse.intensity = 0.5
        material.roughness.contents = NSColor.orange
        material.roughness.intensity = 0
        material.transparencyMode = .dualLayer
        material.transparent.contents = NSColor(calibratedWhite: 1, alpha: 0.6)
        material.transparent.intensity = 0.5
        return material
    }()

    static var oneLed: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = NSColor.orange
        material.metalness.intensity = 0.5
        material.diffuse.contents = NSColor.orange
        material.diffuse.intensity = 0.5
        material.roughness.contents = NSColor.orange
        material.roughness.intensity = 0
        material.transparencyMode = .dualLayer
        material.transparent.contents = NSColor(calibratedWhite: 1, alpha: 0.8)
        material.transparent.intensity = 0.5
        material.emission.contents = NSColor.orange
        material.emission.intensity = 0.75
        return material
    }()

    static func material(for state: State) -> SCNMaterial {
        switch state {
        case .unknown: return unknownComponent
        case .zero: return zeroComponent
        case .one: return oneComponent
        }
    }
}
