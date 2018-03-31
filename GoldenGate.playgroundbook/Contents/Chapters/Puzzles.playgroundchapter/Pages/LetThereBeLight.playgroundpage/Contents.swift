//#-hidden-code

import PlaygroundSupport

let liveViewProxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
let playgroundPageController = PlaygroundPageController(
    liveViewProxy: liveViewProxy,
    successStatus: .pass(message: "Good job!\n\n[Next Puzzle](@next)"),
    failureStatus: .fail(hints: ["Remember that tapping a wire changes its orientation."],
                         solution: "Type `showSolution()` to show one possibility."))
liveViewProxy.delegate = playgroundPageController

//#-end-hidden-code
/*:

 # Welcome to Golden Gate!
 During the next few minutes, you'll learn how to use logic gates to your advantage and build your own digital circuits—let's get started!

 ## First Things First
 In the digital world of ones and zeros, components can have only one of two states: on or off, true or false. (Technically, there might also be a third _high impedance_ state, which is not relevant for these puzzles.)

 This might sound quite limiting but is actually the basis for how this very _iPad_ operates—you can do a lot with [boolean logic](glossary://BooleanLogic), i.e. the art of combining ones and zeros to do more stuff!

 Here are three components you should know about: [inverters](glossary://Inverter), [and gates](glossary://AndGate), and [or gates](glossary://OrGate).

 ---

 # Let There Be Light!
 To get started, place a few wires connecting the switch, [inverter](glossary://Inverter), and LED.

 * Callout(Your Goal):
 Connect the LED to the switch and make sure that it only lights up when the switch is off.

 ## Here Is How It Works
 - Use Drag'n'Drop to add or move a [component](glossary://Component)
 - Remove a component by long-pressing (a puzzle's inputs and outputs cannot be removed)
 - Tap a switch to flip its value or a wire to cycle through possible orientations
 - Outputs are always on the right and inputs on the left

 * Note:
 Tap _Run My Code_ if you want to check your solution. Once tapped, it will continuously assert your progress.

 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, showPuzzle(), showSolution())
//#-editable-code
//#-end-editable-code
