import PlaygroundSupport

let controller = UIKitCircuitViewController()
controller.circuit = Circuit.named("Clock") ?? Circuit()

PlaygroundPage.current.liveView = controller
