//
//  CircuitDocument.swift
//  GoldenGateSandbox
//
//  Created by Steffen Ryll on 25.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import Cocoa

final class CircuitDocument : NSDocument {
    var circuit = Circuit()

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("SandboxWindowController")
        guard let windowController = storyboard.instantiateController(withIdentifier: identifier) as? NSWindowController else {
            fatalError("Cannot create sandbox window.")
        }
        addWindowController(windowController)

        controller.circuit = circuit
    }

    override func data(ofType typeName: String) throws -> Data {
        circuit = controller.circuit ?? circuit
        return try JSONEncoder().encode(circuit)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        circuit = try JSONDecoder().decode(Circuit.self, from: data)
    }

    var controller: CircuitEditorViewController {
        guard let controller = windowControllers.first?.contentViewController as? CircuitEditorViewController else { fatalError() }
        return controller
    }
}
