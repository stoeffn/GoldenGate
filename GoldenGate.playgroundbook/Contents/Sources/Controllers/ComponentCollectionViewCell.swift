//
//  ComponentCollectionViewCell.swift
//  GoldenGate
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

        public override init(frame: CGRect) {
            super.init(frame: frame)
            initUserInterface()
        }

        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            initUserInterface()
        }

        var component: Composable! {
            didSet {
                componentNode = nodeController(for: component).node
                sceneView.scene = SCNScene(named: componentPreviewSceneName)
                sceneView.scene?.rootNode.addChildNode(componentNode)
            }
        }

        // MARK: - User Interface

        private(set) lazy var titleLabel: UILabel = {
            let frame = CGRect(x: 0, y: bounds.size.height - 32, width: bounds.size.width, height: 32)
            let label = UILabel(frame: frame)
            label.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            label.font = .preferredFont(forTextStyle: .headline)
            label.textColor = .darkGray
            label.textAlignment = .center
            return label
        }()

        private(set) lazy var sceneView: SCNView = {
            let frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.width)
            let view = SCNView(frame: frame)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.backgroundColor = .clear
            return view
        }()

        private(set) var componentNode: SCNNode!

        private func initUserInterface() {
            addSubview(titleLabel)
            addSubview(sceneView)
        }
    }

#endif
