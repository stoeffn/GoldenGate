//#-hidden-code

import PlaygroundSupport

let liveViewProxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
let playgroundPageController = PlaygroundPageController(
    liveViewProxy: liveViewProxy,
    successStatus: .pass(message: "Cool, thanks for fixing the lights!\nBy the way: What you've just created is also known as an _exclusive or_.\n\n[Continue](@next)"),
    failureStatus: .fail(hints: [
                            "You will need these inverters already in place.",
                            "More complex logic might require cascading multiple gates."
                         ], solution: "TODO"))
liveViewProxy.delegate = playgroundPageController

//#-end-hidden-code
/*:

 # Light Relief
 Do you know those staircases with two light switches—one at the bottom and one at the top—where flipping either one turns the light on or off?

 They are pretty useful because it would be pointless if you had to go downstairs to turn of the lights after needing them to go upstairs.

 * Callout(Your Goal):
 Connect the LED in such a way that triggering either switch will change whether it is on or off. The LED should also be off when both switches are off.

 Keep in mind that you can make a wire that faces all four directions bridging by tapping on it!

 * Note:
 Take the live view fullscreen by dragging its border in order to view all of the circuit.

 */
//#-code-completion(everything, hide)
//#-editable-code Nothing to Code Here
//#-end-editable-code
