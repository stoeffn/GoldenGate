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
        let controller = UIKitCircuitViewController()
        controller.circuit = Circuit.named("Clock") ?? Circuit()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        return true
    }
}
