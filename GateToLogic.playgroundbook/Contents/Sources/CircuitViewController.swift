//
//  CircuitViewController.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 26.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import UIKit

public final class CircuitViewController : UIViewController {
    private var circuitSceneViewController: CircuitSceneViewController?

    override public func viewDidLoad() {
        super.viewDidLoad()
        circuit = Circuit()
    }

    var circuit: Circuit? {
        get { return circuitSceneViewController?.circuit }
        set {
            circuitSceneViewController?.view.removeFromSuperview()

            guard let circuit = newValue else { return }
            let controller = CircuitSceneViewController(circuit: circuit)

            view.addSubview(controller.view)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

            circuitSceneViewController = controller
        }
    }
}
