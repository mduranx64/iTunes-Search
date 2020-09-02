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
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configureWindow(UIWindow())
        return true
    }
    
    func configureWindow(_ window: UIWindow) {
        
        let remoteSearchLoader = RemoteSearchLoader(client: httpClient)
        let localSearchLoader = LocalSearchLoader(searchCache: InMemorySearchChace())
        
        self.window = window
        window.rootViewController = UINavigationController(
            rootViewController: SearchUIComposer.searchComposedWith(
                searchLoader: SearchLoaderWithFallbackComposite(
                    primary: remoteSearchLoader,
                    fallback: localSearchLoader))
        )
        window.makeKeyAndVisible()
    }
}

