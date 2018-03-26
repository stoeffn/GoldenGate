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

        override public func viewDidLoad() {
            super.viewDidLoad()

            view.addGestureRecognizer(tapGestureRecognizer)
        }

        // MARK: - User Interface

        override public var prefersStatusBarHidden: Bool {
            return true
        }

        // MARK: - User Interaction

        private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))

        @IBAction
        private func didTap(_ sender: UIGestureRecognizer) {
            guard let position = circuitSceneViewController?.position(at: sender.location(in: view)) else { return }
            circuitSceneViewController?.circuit[position]?.trigger()
        }
    }

#endif
