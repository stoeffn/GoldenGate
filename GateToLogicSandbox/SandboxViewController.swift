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

        circuitSceneViewController.circuit.add(Constant(position: GridPoint(x: 0, y: 0), value: true))
        circuitSceneViewController.circuit.add(Wire(position: GridPoint(x: 1, y : 0), orientations: [.left, .right]))
        circuitSceneViewController.circuit.add(Wire(position: GridPoint(x: 2, y : 0), orientations: [.left, .bottom, .right]))
        circuitSceneViewController.circuit.add(Wire(position: GridPoint(x: 3, y : 0), orientations: [.left, .right]))
        circuitSceneViewController.circuit.add(Wire(position: GridPoint(x: 2, y : 1), orientations: [.top, .bottom]))
        circuitSceneViewController.circuit.add(Gate(position: GridPoint(x: 2, y : 2), operator: .and))
        circuitSceneViewController.circuit.add(Wire(position: GridPoint(x: 3, y : 2), orientations: [.left, .right]))
        circuitSceneViewController.circuit.add(Led(position: GridPoint(x: 4, y: 0)))
        circuitSceneViewController.circuit.add(Led(position: GridPoint(x: 4, y: 2)))
    }
}
