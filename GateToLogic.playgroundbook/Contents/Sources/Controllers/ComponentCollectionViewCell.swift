//
//  ComponentCollectionViewCell.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 26.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

#if os(iOS)

    import SceneKit
    import UIKit

    public final class ComponentCollectionViewCell : UICollectionViewCell {
        static let reuseIdentifier = "ComponentCollectionViewCell"

        // MARK: - Life Cycle

        var component: Composable! {
            didSet {
                controller = nodeController(for: component)

                sceneView.scene = SCNScene(named: componentPreviewSceneName)
                sceneView.scene?.rootNode.addChildNode(controller.node)
            }
        }

        // MARK: - User Interface

        @IBOutlet var titleLabel: UILabel!

        @IBOutlet var sceneView: SCNView!

        private var controller: NodeControlling!
    }

#endif
