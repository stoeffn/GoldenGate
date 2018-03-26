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

            view.addGestureRecognizer(tapGestureRecognizer)
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
    }

#endif
