//
//  SandboxViewController.swift
//  GateToLogicSandbox
//
//  Created by Steffen Ryll on 23.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import SceneKit

final class SandboxViewController : NSViewController {
    private var circuitSceneViewController: CircuitSceneViewController?

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

    private var currentComponentPosition: GridPoint?

    @IBOutlet var addComponentMenu: NSMenu!

    @IBOutlet var componentContextMenu: NSMenu!

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)

        currentComponentPosition = circuitSceneViewController?.position(at: view.convert(event.locationInWindow, to: nil))
        guard let position = currentComponentPosition else { return }

        guard circuitSceneViewController?.circuit[position] != nil else { return}

        circuitSceneViewController?.circuit[position]?.trigger()
    }

    override func rightMouseDown(with event: NSEvent) {
        super.rightMouseDown(with: event)

        currentComponentPosition = circuitSceneViewController?.position(at: view.convert(event.locationInWindow, to: nil))
        guard let position = currentComponentPosition else { return }

        guard let component = circuitSceneViewController?.circuit[position] else {
            return NSMenu.popUpContextMenu(addComponentMenu, with: event, for: view)
        }

        componentContextMenu.items.first?.title = String(reflecting: component)
        NSMenu.popUpContextMenu(componentContextMenu, with: event, for: view)
    }

    @IBAction
    func printComponentDescription(_ sender: Any) {
        guard
            let position = currentComponentPosition,
            let component = circuitSceneViewController?.circuit[position]
        else { return }
        print(String(reflecting: component))
    }

    @IBAction
    func removeComponent(_ sender: Any) {
        guard let position = currentComponentPosition else { return }
        circuitSceneViewController?.circuit[position] = nil
    }

    @IBAction
    func addZeroConstantComponent(_ sender: Any?) {
        guard let position = currentComponentPosition else { return }
        circuitSceneViewController?.circuit[position] = Constant(value: false)
    }

    @IBAction
    func addOneConstantComponent(_ sender: Any?) {
        guard let position = currentComponentPosition else { return }
        circuitSceneViewController?.circuit[position] = Constant(value: true)
    }

    @IBAction
    func addAndGateComponent(_ sender: Any?) {
        guard let position = currentComponentPosition else { return }
        circuitSceneViewController?.circuit[position] = Gate(operator: .and)
    }

    @IBAction
    func addOrGateComponent(_ sender: Any?) {
        guard let position = currentComponentPosition else { return }
        circuitSceneViewController?.circuit[position] = Gate(operator: .or)
    }

    @IBAction
    func addLedComponent(_ sender: Any?) {
        guard let position = currentComponentPosition else { return }
        circuitSceneViewController?.circuit[position] = Led()
    }

    @IBAction
    func addWireComponent(_ sender: Any?) {
        guard let position = currentComponentPosition else { return }
        let orientations = circuitSceneViewController?.circuit.suggestedOrientations(forWireAt: position) ?? []
        circuitSceneViewController?.circuit[position] = Wire(orientations: orientations)
    }
}
