//
//  AppDelegate.swift
//  GateToLogicSandbox-iOS
//
//  Created by Steffen Ryll on 26.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate : UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        (window?.rootViewController as? UIKitCircuitViewController)?.circuit = Circuit.named("Clock") ?? Circuit()
        return true
    }
}
