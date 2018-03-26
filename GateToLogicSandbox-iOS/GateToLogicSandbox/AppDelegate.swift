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

    func circuit(named name: String) -> Circuit? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "logic") else { return nil }
        return try? JSONDecoder().decode(Circuit.self, from: Data(contentsOf: url))
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let controller = CircuitViewController()
        controller.circuit = circuit(named: "Clock") ?? Circuit()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        return true
    }
}
