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
    
    private lazy var inMemorySearchChace: InMemorySearchChace = {
        InMemorySearchChace()
    }()
    
    private lazy var localSearchLoader: LocalSearchLoader = {
        LocalSearchLoader(searchCache: inMemorySearchChace)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configureWindow(UIWindow())
        return true
    }
    
    func configureWindow(_ window: UIWindow) {
        
        let remoteSearchLoader = RemoteSearchLoader(client: httpClient)
        
        self.window = window
        
        
        
        let mainSearchViewController = SearchUIComposer.searchComposedWith(
        searchLoader: SearchLoaderWithFallbackComposite(
            primary: SearchLoaderCacheDecorator(
                decoratee: remoteSearchLoader,
                searchCache: inMemorySearchChace),
            fallback: localSearchLoader))
            
        let navigationController = UINavigationController(
            rootViewController: mainSearchViewController
        )
        
        mainSearchViewController.detailsViewNavigation = { [weak navigationController] song in
            
            let detailsViewController = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
            detailsViewController.song = song
            navigationController?.pushViewController(detailsViewController, animated: true)
        }
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

