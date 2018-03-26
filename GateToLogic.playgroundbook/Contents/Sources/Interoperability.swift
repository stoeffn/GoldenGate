//
//  Interoperability.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 26.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

#if os(iOS)

    import UIKit

    public typealias Color = UIColor

    public typealias ViewController = UIViewController

#elseif os(OSX)

    import Cocoa

    public typealias Color = NSColor

    public typealias ViewController = NSViewController

#endif
