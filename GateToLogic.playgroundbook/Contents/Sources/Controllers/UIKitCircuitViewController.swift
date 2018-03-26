//
//  UIKitCircuitViewController.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 26.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

#if os(iOS)

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
                circuitSceneViewController?.view.addInteraction(UIDropInteraction(delegate: self))
            }
        }

        // MARK: - User Interface

        override public var prefersStatusBarHidden: Bool {
            return true
        }

        @IBOutlet var componentsCollectionView: UICollectionView!

        private var availableComponents: [(title: String, component: Composable)] = [
            (title: "Zero Constant", component: Constant(value: false)),
            (title: "One Constant", component: Constant(value: true))
        ]

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
            let component = AnyPositionedComponent(component: availableComponents[indexPath.row].component, position: .zero)
            let provider = NSItemProvider()
            provider.registerDataRepresentation(forTypeIdentifier: AnyPositionedComponent.identifier, visibility: .ownProcess) { completion in
                completion(try? JSONEncoder().encode(component), nil)
                return nil
            }
            return [UIDragItem(itemProvider: provider)]
        }
    }

    // MARK: - Dropping Components

    extension UIKitCircuitViewController : UIDropInteractionDelegate {
        public func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
            return session.hasItemsConforming(toTypeIdentifiers: [AnyPositionedComponent.identifier])
        }

        public func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
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
