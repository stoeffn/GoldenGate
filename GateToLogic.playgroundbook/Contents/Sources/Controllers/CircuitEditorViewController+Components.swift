//
//  CircuitEditorViewController+Components.swift
//  GateToLogic
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
