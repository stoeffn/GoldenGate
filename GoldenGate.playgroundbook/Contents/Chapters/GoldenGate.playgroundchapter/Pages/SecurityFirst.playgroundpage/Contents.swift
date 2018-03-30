//#-hidden-code

import PlaygroundSupport

let liveViewProxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
let playgroundPageController = PlaygroundPageController(
    liveViewProxy: liveViewProxy,
    successStatus: .pass(message: "Great Thinking—it's now safe to operate that um… LED!\n\n[Next Puzzle](@next)"),
    failureStatus: .fail(hints: ["Think about which logic gate might match the situtation."],
                         solution: "Connect both inputs to an `And` gate and its output to the LED."))
liveViewProxy.delegate = playgroundPageController

//#-end-hidden-code
/*:

 # Welcome to Golden Gate!
 During the next few minutes, you'll learn how to use logic gates to your advantage and build your own digital circuits—let's get started!

 ## First Things First
 In the digital world of ones and zeros, components can have only one of two states: on or off, true or false.¹

 This might sound quite limiting but is actually the basis for how this very _iPad_ operates—you can do a lot with [boolean logic](glossary://BooleanLogic), i.e. the art of combining ones and zeros to do more stuff!

 Here are three components you should know about: [inverters](glossary://Inverter), [and gates](glossary://AndGate), and [or gates](glossary://OrGate).

 ---

 # Safety First
 Some industrial machines need can be very dangerous for humans to operate. Let's pretend the LED on the right is a machine that can cause serious harm when activited while an operator's arm is resting on it.

 Luckily, there is the concept of two-hand control devices: In order to activate the machine, the operator has simultaneously push two buttons that are an arm's length apart. Thus, he can only activate the machine from a safe distance.

 Let's build that security mechanism!

 * Callout(Your Goal):
 Connect the LED to both inputs in such a way that it only lights up when both are true.

 ## Here Is How It Works
 The simulator lets you place switches, logic gates, LEDs, and more!
 - Use Drag'n'Drop to add or move a component
 - Remove a component by long-pressing (a puzzle's inputs and outputs cannot be removed)
 - Tap a switch to flip its value or a wire to cycle through possible orientations
 - Just like in the real world, gates have a little bit of a delay, which is exaggarated in this simulation
 - Outputs are always on the right and inputs on the left (and sometimes on the top and/or bottom as well)
 - Importantly, a disconnected input is not _zero_ or _false_ but undefined

 * Note:
 Tap _Run My Code_ if you want to check your solution. Once tapped, it will continuously assert your progress.

 ---

 ## Footnotes
 ¹ Technically, there might also be a third _high impedance_ state, which is not relevant for these puzzles.

 */
//#-code-completion(everything, hide)
//#-editable-code Nothing to Code Here
//#-end-editable-code
