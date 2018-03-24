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

    private var rightClickEvent: NSEvent?

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

    override func rightMouseDown(with event: NSEvent) {
        super.rightMouseDown(with: event)

        rightClickEvent = event

        guard let position = circuitSceneViewController.position(at: view.convert(event.locationInWindow, to: nil)) else { return }

        guard circuitSceneViewController.circuit.components[position] == nil else {
            let menu = NSMenu(title: "Context")
            menu.addItem(NSMenuItem(title: "Remove", action: #selector(remove(sender:)), keyEquivalent: ""))
            return NSMenu.popUpContextMenu(menu, with: event, for: view)
        }

        let menu = NSMenu(title: "Context")
        menu.addItem(NSMenuItem(title: "Add Constant", action: #selector(addConstant(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Add And Gate", action: #selector(addAndGate(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Add Or Gate", action: #selector(addOrGate(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Add Led", action: #selector(addLed(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Add Wire", action: #selector(addWire(sender:)), keyEquivalent: ""))
        NSMenu.popUpContextMenu(menu, with: event, for: view)
    }

    @objc
    func remove(sender: Any?) {
        guard let event = rightClickEvent else { fatalError() }
        guard let position = circuitSceneViewController.position(at: view.convert(event.locationInWindow, to: nil)) else { return }
        circuitSceneViewController.circuit.removeComponent(at: position)
    }

    @objc
    func addConstant(sender: Any?) {
        guard let event = rightClickEvent else { fatalError() }
        circuitSceneViewController.set(Constant(value: true), at: view.convert(event.locationInWindow, to: nil))
    }

    @objc
    func addAndGate(sender: Any?) {
        guard let event = rightClickEvent else { fatalError() }
        circuitSceneViewController.set(Gate(operator: .and), at: view.convert(event.locationInWindow, to: nil))
    }

    @objc
    func addOrGate(sender: Any?) {
        guard let event = rightClickEvent else { fatalError() }
        circuitSceneViewController.set(Gate(operator: .or), at: view.convert(event.locationInWindow, to: nil))
    }

    @objc
    func addLed(sender: Any?) {
        guard let event = rightClickEvent else { fatalError() }
        circuitSceneViewController.set(Led(), at: view.convert(event.locationInWindow, to: nil))
    }

    @objc
    func addWire(sender: Any?) {
        guard let event = rightClickEvent else { fatalError() }
        circuitSceneViewController.set(Wire(orientations: [.left, .right, .top, .bottom]), at: view.convert(event.locationInWindow, to: nil))
    }
}
