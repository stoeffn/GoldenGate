import PlaygroundSupport

let liveViewProxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
let playgroundPageController = PlaygroundPageController(liveViewProxy: liveViewProxy)
liveViewProxy.delegate = playgroundPageController
