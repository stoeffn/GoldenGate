//
//  ComponentCollectionViewCell.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 29.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import PlaygroundSupport

public extension PlaygroundRemoteLiveViewProxy {
    public func send(_ command: PlaygroundCommands) {
        send(.string(command.rawValue))
    }
}

public final class PlaygroundPageController : PlaygroundRemoteLiveViewProxyDelegate {
    private let liveViewProxy: PlaygroundRemoteLiveViewProxy

    public init(liveViewProxy: PlaygroundRemoteLiveViewProxy) {
        self.liveViewProxy = liveViewProxy
        self.liveViewProxy.send(.runAssertions)

        PlaygroundPage.current.needsIndefiniteExecution = true
    }

    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) { }

    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        guard case let .string(rawCommand) = message, let command = PlaygroundCommands(rawValue: rawCommand) else { return }

        switch command {
        case .handleAssertionSuccess:
            PlaygroundPage.current.assessmentStatus = .pass(message: nil)
            PlaygroundPage.current.finishExecution()
        case .handleAssertionFailure:
            PlaygroundPage.current.assessmentStatus = .fail(hints: ["Test"], solution: nil)
        case .runAssertions:
            return
        }
    }
}
