//
//  SCNGeometryTessellator+Common.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 31.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

extension SCNGeometryTessellator {
    static let `default`: SCNGeometryTessellator = {
        let tessellator = SCNGeometryTessellator()
        tessellator.isAdaptive = true
        tessellator.isScreenSpace = true
        tessellator.maximumEdgeLength = 50
        tessellator.smoothingMode = .pnTriangles
        return tessellator
    }()
}
