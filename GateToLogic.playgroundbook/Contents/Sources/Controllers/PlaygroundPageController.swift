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

    private let successStatus: PlaygroundPage.AssessmentStatus?

    private let failureStatus: PlaygroundPage.AssessmentStatus?

    public init(liveViewProxy: PlaygroundRemoteLiveViewProxy, successStatus: PlaygroundPage.AssessmentStatus? = nil,
                failureStatus: PlaygroundPage.AssessmentStatus? = nil) {
        self.liveViewProxy = liveViewProxy
        self.successStatus = successStatus
        self.failureStatus = failureStatus

        liveViewProxy.send(.runAssertions)
        PlaygroundPage.current.needsIndefiniteExecution = true
    }

    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) { }

    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        guard case let .string(rawCommand) = message, let command = PlaygroundCommands(rawValue: rawCommand) else { return }

        switch command {
        case .handleAssertionSuccess:
            PlaygroundPage.current.assessmentStatus = successStatus
            PlaygroundPage.current.finishExecution()
        case .handleAssertionFailure where PlaygroundPage.current.assessmentStatus == nil:
            PlaygroundPage.current.assessmentStatus = failureStatus
        case .handleAssertionFailure, .runAssertions:
            return
        }
    }
}
