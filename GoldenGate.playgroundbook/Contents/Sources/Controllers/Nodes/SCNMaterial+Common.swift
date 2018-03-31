//
//  SCNMaterial+Common.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 25.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

extension SCNMaterial {
    static var component: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = Color.white
        material.metalness.intensity = 0.2
        material.diffuse.contents = Color.white
        material.diffuse.intensity = 1.2
        material.roughness.contents = Color.white
        material.roughness.intensity = 0.2
        return material
    }()

    static var unknownComponent: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = Color.white
        material.metalness.intensity = 0
        material.diffuse.contents = Color.white
        material.diffuse.intensity = 1
        material.roughness.contents = Color.white
        material.roughness.intensity = 0.25
        return material
    }()

    static var zeroComponent: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = Color(red: 1, green: 0.23, blue: 0.19, alpha: 1)
        material.metalness.intensity = 0
        material.diffuse.contents = Color(red: 1, green: 0.23, blue: 0.19, alpha: 1)
        material.diffuse.intensity = 1
        material.roughness.contents = Color(red: 1, green: 0.23, blue: 0.19, alpha: 1)
        material.roughness.intensity = 0.25
        return material
    }()

    static var oneComponent: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = Color(red: 0.3, green: 0.85, blue: 0.39, alpha: 1)
        material.metalness.intensity = 0
        material.diffuse.contents = Color(red: 0.3, green: 0.85, blue: 0.39, alpha: 1)
        material.diffuse.intensity = 1
        material.roughness.contents = Color(red: 0.3, green: 0.85, blue: 0.39, alpha: 1)
        material.roughness.intensity = 0.25
        material.emission.contents = Color(red: 0.3, green: 0.85, blue: 0.39, alpha: 1)
        material.emission.intensity = 0.5
        return material
    }()

    static var zeroLed: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = Color(red: 1, green: 0.58, blue: 0, alpha: 1)
        material.metalness.intensity = 0
        material.diffuse.contents = Color(red: 1, green: 0.58, blue: 0, alpha: 1)
        material.diffuse.intensity = 1
        material.roughness.contents = Color(red: 1, green: 0.58, blue: 0, alpha: 1)
        material.roughness.intensity = 0
        material.emission.contents = Color(red: 1, green: 0.58, blue: 0, alpha: 1)
        material.emission.intensity = 0.25
        return material
    }()

    static var oneLed: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = Color(red: 1, green: 0.58, blue: 0, alpha: 1)
        material.metalness.intensity = 0
        material.diffuse.contents = Color(red: 1, green: 0.58, blue: 0, alpha: 1)
        material.diffuse.intensity = 0.5
        material.roughness.contents = Color(red: 1, green: 0.58, blue: 0, alpha: 1)
        material.roughness.intensity = 0
        material.emission.contents = Color(red: 1, green: 0.58, blue: 0, alpha: 1)
        material.emission.intensity = 2
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
