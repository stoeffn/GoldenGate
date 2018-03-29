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

#endif
