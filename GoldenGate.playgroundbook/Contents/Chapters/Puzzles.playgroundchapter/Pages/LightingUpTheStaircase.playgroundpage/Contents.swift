//#-hidden-code

import PlaygroundSupport

let liveViewProxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
let playgroundPageController = PlaygroundPageController(
    liveViewProxy: liveViewProxy,
    successStatus: .pass(message: "Cool, thanks for fixing the lights!\nBy the way: What you've just created is also known as an _exclusive or_.\n\n[Continue](@next)"),
    failureStatus: .fail(hints: [
                            "Think about all possible input variations and how the output needs to behave.",
                            "More complex logic might require cascading multiple gates."
                         ], solution: "Type `showSolution()` to show one possibility."))
liveViewProxy.delegate = playgroundPageController

//#-end-hidden-code
/*:

 # Lighting Up the Staircase
 Do you know those staircases with two light switches—one at the bottom and one at the top—where flipping either one turns the light on or off?

 They are pretty useful because it would be pointless if you had to go downstairs to turn of the lights after needing them to go upstairs.

 * Callout(Your Goal):
 Connect the LED in such a way that triggering either switch will change whether it is on or off. The LED should also be off when both switches are off.

 To get you started, I've placed all the wires. Feel free, however, to remove them as you like—there are multiple ways!

 Keep in mind that you can make a wire that faces all four directions bridging by tapping on it.

 * Note:
 Take the live view fullscreen by dragging its border in order to view all of the circuit.

 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, showPuzzle(), showSolution())
//#-editable-code
//#-end-editable-code
