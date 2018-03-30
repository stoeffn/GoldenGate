//
//  CircuitEditorViewController+Components.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 28.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

#if os(iOS)

    import SceneKit
    import UIKit

    // MARK: - Tool Bar Data Source

    extension CircuitEditorViewController : UICollectionViewDataSource {
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return availableComponents.count
        }

        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComponentCollectionViewCell.reuseIdentifier, for: indexPath)
            (cell as? ComponentCollectionViewCell)?.titleLabel.text = availableComponents[indexPath.row].title
            (cell as? ComponentCollectionViewCell)?.component = availableComponents[indexPath.row].component
            return cell
        }
    }

    // MARK: - Tool Bar Delegate

    extension CircuitEditorViewController : UICollectionViewDelegate {
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            updateComponentRotations()
        }

        func updateComponentRotations() {
            componentsCollectionView.visibleCells
                .flatMap { $0 as? ComponentCollectionViewCell }
                .map { (node: $0.componentNode, offset: componentsCollectionView.contentOffset.x) }
                .forEach { $0.node.eulerAngles = SCNVector3(x: -.pi / 2, y: Float($0.offset) / 128, z: 0) }
        }
    }

    // MARK: - Dragging Components from the Tool Bar

    extension CircuitEditorViewController : UICollectionViewDragDelegate {
        public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession,
                                   at indexPath: IndexPath) -> [UIDragItem] {
            let itemProvider = availableComponents[indexPath.row].component.itemProvider()
            return [UIDragItem(itemProvider: itemProvider)]
        }

        public func collectionView(_ collectionView: UICollectionView,
                                   dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
            let parameters = UIDragPreviewParameters()
            parameters.visiblePath = UIBezierPath(rect: previewSceneView.bounds)
            return parameters
        }
    }

#endif
