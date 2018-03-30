//
//  CircuitEditorViewController+MenuAction.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 28.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

#if os(OSX)

    extension CircuitEditorViewController {
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
        func addConstantComponent(_ sender: Any?) {
            guard let position = currentComponentPosition else { return }
            circuitSceneViewController?.circuit[position] = Constant(value: true)
        }

        @IBAction
        func addNotGateComponent(_ sender: Any?) {
            guard let position = currentComponentPosition else { return }
            circuitSceneViewController?.circuit[position] = Inverter()
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
        func addAutomaticWireComponent(_ sender: Any?) {
            guard let position = currentComponentPosition else { return }
            let orientations = circuitSceneViewController?.circuit.suggestedOrientations(forWireAt: position) ?? []
            circuitSceneViewController?.circuit[position] = Wire(orientations: orientations)
        }

        @IBAction
        func addStraightWireComponent(_ sender: Any?) {
            guard let position = currentComponentPosition else { return }
            circuitSceneViewController?.circuit[position] = Wire(orientations: [.left, .right])
        }

        @IBAction
        func addAngledWireComponent(_ sender: Any?) {
            guard let position = currentComponentPosition else { return }
            circuitSceneViewController?.circuit[position] = Wire(orientations: [.left, .top])
        }

        @IBAction
        func addTeeWireComponent(_ sender: Any?) {
            guard let position = currentComponentPosition else { return }
            circuitSceneViewController?.circuit[position] = Wire(orientations: [.left, .top, .right])
        }

        @IBAction
        func addAllWireComponent(_ sender: Any?) {
            guard let position = currentComponentPosition else { return }
            circuitSceneViewController?.circuit[position] = Wire(orientations: [.left, .top, .right, .bottom])
        }
    }

#endif
