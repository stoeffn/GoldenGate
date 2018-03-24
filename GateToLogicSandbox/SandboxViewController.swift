//
//  SandboxViewController.swift
//  GateToLogicSandbox
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class SandboxViewController : NSViewController {
    private lazy var circuitSceneViewController = CircuitSceneViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(circuitSceneViewController.view)
        circuitSceneViewController.view.translatesAutoresizingMaskIntoConstraints = false
        circuitSceneViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        circuitSceneViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        circuitSceneViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        circuitSceneViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
