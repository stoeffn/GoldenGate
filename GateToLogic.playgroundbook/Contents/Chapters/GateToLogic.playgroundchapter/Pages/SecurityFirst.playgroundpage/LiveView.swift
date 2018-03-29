import PlaygroundSupport

let controller = CircuitEditorViewController()
controller.circuit = Circuit.named("Puzzle")
controller.circuitDidMeetAssertions = {
    controller.send(.boolean(true))
}

PlaygroundPage.current.liveView = controller
