//#-hidden-code

import PlaygroundSupport

let liveViewProxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
let playgroundPageController = PlaygroundPageController(
    liveViewProxy: liveViewProxy,
    successStatus: .pass(message: "Great Thinking—it's now safe to operate that um… LED!\n\n[Next Puzzle](@next)"),
    failureStatus: .fail(hints: ["Think about which logic gate might match the situation."],
                         solution: "Type `showSolution()` to show one possibility."))
liveViewProxy.delegate = playgroundPageController

//#-end-hidden-code
/*:

 # Safety First
 Some industrial machines need can be very dangerous for humans to operate. Let's pretend the LED on the right is a machine that can cause serious harm when activited while an operator's arm is resting on it.

 Luckily, there is the concept of two-hand control devices: In order to activate the machine, the operator has simultaneously push two buttons that are an arm's length apart. Thus, he can only activate the machine from a safe distance.

 Let's build that security mechanism!

 * Callout(Your Goal):
 Connect the LED to both switches (this time, think of them as buttons) in such a way that it only lights up when both are true.

 ## A Few More Tips
 - [And gates](glossary://AndGate) and [or gates](glossary://OrGate) have inputs on the top, left, and bottom
 - Just like in the real world, gates have a little bit of a delay, which is exaggarated in this simulation—this is called [propagation delay](glossary://PropagationDelay)
 - Importantly, a disconnected input is not _zero_ or _false_ but unknown and will not be taken into account

 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, showPuzzle(), showSolution())
//#-editable-code
//#-end-editable-code
