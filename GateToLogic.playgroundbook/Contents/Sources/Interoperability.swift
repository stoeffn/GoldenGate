//
//  Interoperability.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 26.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

#if os(iOS)

    import UIKit

    typealias Color = UIColor

#elseif os(OSX)

    import Cocoa

    typealias Color = NSColor

#endif
