import PlaygroundSupport

let controller = CircuitEditorViewController()
controller.circuit = Circuit.named("Puzzle")

PlaygroundPage.current.liveView = controller
