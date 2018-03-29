//
//  AppDelegate.swift
//  GoldenGateSandbox-iOS
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
        let controller = CircuitEditorViewController()
        controller.circuit = Circuit.named("Puzzle")
        controller.didAssertCircuit = { isSuccess in
            print("Did assert circuit with \(isSuccess ? "success" : "failure")")
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()

        return true
    }
}
