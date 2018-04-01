//
//  CircuitEditorViewController+Gestures.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 28.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

#if os(iOS)

    import SceneKit
    import UIKit

    // MARK: - User Interaction

    public extension CircuitEditorViewController {
        @IBAction
        func didTap(_ gestureRecognizer: UITapGestureRecognizer) {
            guard
                gestureRecognizer.state == .ended,
                let position = circuitSceneViewController?.position(at: gestureRecognizer.location(in: view))
            else { return }

            circuitSceneViewController?.circuit[position]?.trigger()
            assertCircuit()
        }

        @IBAction
        func didLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
            guard
                gestureRecognizer.state == .ended,
                let position = circuitSceneViewController?.position(at: gestureRecognizer.location(in: view)),
                let component = circuitSceneViewController?.circuit[position],
                !component.isLocked
            else { return }

            circuitSceneViewController?.circuit[position] = nil
            assertCircuit()
        }
    }

    // MARK: - Dragging Components from the Scene

    extension CircuitEditorViewController : UIDragInteractionDelegate {
        // MARK: Performing the Drag

        public func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
            guard
                let position = circuitSceneViewController?.position(at: session.location(in: view)),
                let component = circuitSceneViewController?.circuit[position],
                !component.isLocked
            else { return [] }

            let itemProvider = component.itemProvider(at: position)
            return [UIDragItem(itemProvider: itemProvider)]
        }

        // MARK: Animating the Drag Behaviors

        public func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
            session.items.first?.itemProvider.loadComponent { (_, position) in
                guard let position = position else { return }

                self.circuitSceneViewController?.componentNodeControllers[position]?.isHighlighted = true
            }
        }

        public func dragInteraction(_ interaction: UIDragInteraction, item: UIDragItem, willAnimateCancelWith animator: UIDragAnimating) {
            item.itemProvider.loadComponent { (_, position) in
                guard let position = position else { return }

                self.circuitSceneViewController?.componentNodeControllers[position]?.move(to: position, animated: true)
                self.circuitSceneViewController?.componentNodeControllers[position]?.isHighlighted = false
            }
        }

        // MARK: Monitoring Drag Progress

        public func dragInteraction(_ interaction: UIDragInteraction, sessionDidMove session: UIDragSession) {
            session.items.first?.itemProvider.loadComponent { (_, position) in
                guard
                    let position = position,
                    let currentPosition = self.circuitSceneViewController?.position(at: session.location(in: self.view))
                else { return }

                self.circuitSceneViewController?.componentNodeControllers[position]?.move(to: currentPosition, animated: true)
            }
        }

        public func dragInteraction(_ interaction: UIDragInteraction, sessionDidTransferItems session: UIDragSession) {
            session.items.first?.itemProvider.loadComponent { (_, position) in
                guard let position = position else { return }
                self.circuitSceneViewController?.circuit[position] = nil
            }
        }

        // MARK: Providing Drag Previews

        public func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem,
                                    session: UIDragSession) -> UITargetedDragPreview? {
            return nil
        }
    }

    // MARK: - Dropping Components to the Scene

    extension CircuitEditorViewController : UIDropInteractionDelegate {
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
                self.assertCircuit()
            }
        }
    }

#endif
