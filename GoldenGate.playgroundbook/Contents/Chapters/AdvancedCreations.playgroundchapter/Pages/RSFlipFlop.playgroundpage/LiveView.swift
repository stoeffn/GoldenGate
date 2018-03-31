import PlaygroundSupport

let controller = CircuitEditorViewController()
controller.circuit = Circuit.named("RS-Flip-Flop")

PlaygroundPage.current.liveView = controller
