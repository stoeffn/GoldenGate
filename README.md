#  Golden Gate

_A Swift Playground about digital circuits and my 2018 WWDC scholarship submission_

At its core, my Swift Playground Book comprises a logic simulator with accompanying puzzles and explanations as well as solution checker, which doesn’t look for specific components but simulates the learner’s circuit and asserts outputs for various input states. Thus, it is possible to assert progress without discouraging alternative solutions.

The simulator itself is dynamic in a way that lets it update passive components while being modified, which makes for instant visual feedback. Active components update their outputs at a fixed rate and also simulate propagation delay. In other words, my logic simulator also supports feedback loops that enable flip-flops or clocks.

It is built on top of lightweight Swift structs and heavily uses language features such as protocol extensions and synthesized protocol conformance. Thus, it was a breeze to implement Codable support for loading and saving levels as JSON.

This is why I also developed a document-based macOS Sandbox application with AppKit for content creation. It was very easy to reuse code on both macOS and iOS since I’ve employed SceneKit to visualize the logic simulation.

Even though I’ve never touched SceneKit before, it was a great learning experience getting started. I created my textures and images in Sketch and geometries in Blender. Another integral part to my process was—of course—the Xcode Scene editor.

Adding and moving circuit components on iOS couldn’t be easier—thanks to iOS 11’s new Drag’n’Drop API. Triggering and removing components is based on gesture recognizers.
