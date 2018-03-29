import PlaygroundSupport

let controller = CircuitEditorViewController()
controller.circuit = Circuit.named("Puzzle")
controller.didAssertCircuit = { isSuccess in
    controller.send(PlaygroundCommands.fromAssertionResult(isSuccess))
}

PlaygroundPage.current.liveView = controller
