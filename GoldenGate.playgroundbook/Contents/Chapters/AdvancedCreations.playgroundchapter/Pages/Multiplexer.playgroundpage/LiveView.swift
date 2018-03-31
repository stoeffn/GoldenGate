import PlaygroundSupport

let controller = CircuitEditorViewController()
controller.circuit = Circuit.named("Multiplexer")

PlaygroundPage.current.liveView = controller
