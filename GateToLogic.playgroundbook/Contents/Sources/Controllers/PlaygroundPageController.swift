//
//  ComponentCollectionViewCell.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 29.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import PlaygroundSupport

public final class PlaygroundPageController : PlaygroundRemoteLiveViewProxyDelegate {
    private let liveViewProxy: PlaygroundRemoteLiveViewProxy

    public init(liveViewProxy: PlaygroundRemoteLiveViewProxy) {
        self.liveViewProxy = liveViewProxy
        self.liveViewProxy.send(.boolean(true))

        PlaygroundPage.current.needsIndefiniteExecution = true
    }

    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) { }

    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        PlaygroundPage.current.assessmentStatus = .pass(message: nil)
        PlaygroundPage.current.finishExecution()
    }
}
