//
//  UIKitCircuitViewController.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 26.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

#if os(iOS)

    import SceneKit
    import UIKit

    public final class UIKitCircuitViewController : CircuitViewController {

        // MARK: - Life Cycle

        public override func viewDidLoad() {
            super.viewDidLoad()

            componentsCollectionView.dragDelegate = self
        }

        public override var circuit: Circuit? {
            get { return super.circuit }
            set {
                super.circuit = newValue
                circuitSceneViewController?.view.addInteraction(UIDragInteraction(delegate: self))
                circuitSceneViewController?.view.addInteraction(UIDropInteraction(delegate: self))
            }
        }

        // MARK: - User Interface

        override public var prefersStatusBarHidden: Bool {
            return true
        }

        @IBOutlet var componentsCollectionView: UICollectionView!

        private var availableComponents: [(title: String, component: Composable)] = [
            (title: "Zero", component: Constant(value: false)),
            (title: "One", component: Constant(value: true))
        ]

        @IBOutlet var previewSceneView: SCNView!

        private func preparePreviewScene(for component: Composable, at location: CGPoint) {
            previewSceneView.center = location
            previewSceneView.scene = SCNScene(named: componentPreviewSceneName)
            previewSceneView.scene?.rootNode.addChildNode(nodeController(for: component).node)
        }

        // MARK: - User Interaction

        @IBAction
        func didTap(_ sender: UIGestureRecognizer) {
            guard let position = circuitSceneViewController?.position(at: sender.location(in: view)) else { return }
            circuitSceneViewController?.circuit[position]?.trigger()
        }

        @IBAction
        func didLongPress(_ sender: UIGestureRecognizer) {
            guard let position = circuitSceneViewController?.position(at: sender.location(in: view)) else { return }
            circuitSceneViewController?.circuit[position] = nil
        }
    }

    // MARK: - Tool Bar Data Source

    extension UIKitCircuitViewController : UICollectionViewDataSource {
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

    extension UIKitCircuitViewController : UICollectionViewDragDelegate {
        public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession,
                                   at indexPath: IndexPath) -> [UIDragItem] {
            return [UIDragItem(itemProvider: availableComponents[indexPath.row].component.itemProvider())]
        }

        public func collectionView(_ collectionView: UICollectionView,
                                   dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ComponentCollectionViewCell else { return nil }
            let parameters = UIDragPreviewParameters()
            parameters.visiblePath = UIBezierPath(rect: cell.sceneView.frame)
            return parameters
        }
    }

    // MARK: - Dragging Components from the Scene

    extension UIKitCircuitViewController : UIDragInteractionDelegate {
        public func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
            guard
                let position = circuitSceneViewController?.position(at: session.location(in: view)),
                let component = circuitSceneViewController?.circuit[position]
            else { return [] }
            return [UIDragItem(itemProvider: component.itemProvider(at: position))]
        }

        public func dragInteraction(_ interaction: UIDragInteraction, sessionDidTransferItems session: UIDragSession) {
            session.items.first?.itemProvider.loadDataRepresentation(forTypeIdentifier: AnyPositionedComponent.identifier) { (data, _) in
                guard
                    let data = data,
                    let anyPositionedComponent = try? JSONDecoder().decode(AnyPositionedComponent.self, from: data),
                    let previousPosition = anyPositionedComponent.position
                else { return }
                self.circuitSceneViewController?.circuit[previousPosition] = nil
            }
        }

        public func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem,
                                    session: UIDragSession) -> UITargetedDragPreview? {
            guard
                let position = circuitSceneViewController?.position(at: session.location(in: view)),
                let component = circuitSceneViewController?.circuit[position]
            else { return nil }
            preparePreviewScene(for: component, at: session.location(in: view))
            return UITargetedDragPreview(view: previewSceneView)
        }

        public func dragInteraction(_ interaction: UIDragInteraction, prefersFullSizePreviewsFor session: UIDragSession) -> Bool {
            return true
        }

        public func dragInteraction(_ interaction: UIDragInteraction, sessionDidMove session: UIDragSession) {
            view.sendSubview(toBack: previewSceneView)
        }
    }

    // MARK: - Dropping Components to the Scene

    extension UIKitCircuitViewController : UIDropInteractionDelegate {
        public func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
            return session.hasItemsConforming(toTypeIdentifiers: [AnyPositionedComponent.identifier])
        }

        public func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
            guard
                let position = circuitSceneViewController?.position(at: session.location(in: view)),
                circuitSceneViewController?.circuit[position] == nil
            else { return UIDropProposal(operation: .cancel) }
            return UIDropProposal(operation: .move)
        }

        public func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
            session.items.first?.itemProvider.loadDataRepresentation(forTypeIdentifier: AnyPositionedComponent.identifier) { (data, _) in
                guard
                    let data = data,
                    let component = try? JSONDecoder().decode(AnyPositionedComponent.self, from: data).component,
                    let position = self.circuitSceneViewController?.position(at: session.location(in: self.view))
                else { return }
                self.circuitSceneViewController?.circuit[position] = component
            }
        }
    }

#endif
