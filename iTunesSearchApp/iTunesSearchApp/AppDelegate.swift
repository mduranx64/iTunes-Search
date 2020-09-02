//
//  AppDelegate.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configureWindow(UIWindow())
        return true
    }
    
    func configureWindow(_ window: UIWindow) {
        self.window = window
        window.rootViewController = UINavigationController(
            rootViewController: MainSearchViewController(
                tableView: UITableView.makeSearchTableView(),
                dataSource: MainSearchDataSourse()
            )
        )
        window.makeKeyAndVisible()
    }
}

