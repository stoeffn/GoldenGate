//
//  CircuitViewController.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 26.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

public class CircuitViewController : ViewController {

    // MARK: - Circuit Management

    private(set) var circuitSceneViewController: CircuitSceneViewController?

    public var circuit: Circuit? {
        get { return circuitSceneViewController?.circuit }
        set {
            circuitSceneViewController?.view.removeFromSuperview()

            guard let circuit = newValue else { return }
            let controller = CircuitSceneViewController(circuit: circuit)

            #if os(iOS)
                view.insertSubview(controller.view, at: 0)
            #else
                view.addSubview(controller.view)
            #endif

            controller.view.translatesAutoresizingMaskIntoConstraints = false
            controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            controller.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 16).isActive = true
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

            circuitSceneViewController = controller
        }
    }
}
