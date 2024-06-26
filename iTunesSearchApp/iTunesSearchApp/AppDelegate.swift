//
//  AppDelegate.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import UIKit
import SearchCache
import SearchAPI

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
    
    private lazy var analytics: Analytics = {
        Analytics()
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configureWindow(UIWindow())
        return true
    }
    
    func configureWindow(_ window: UIWindow) {
        
        let remoteSearchLoader = RemoteSearchLoader(client: httpClient)
        let remoteSearchImageDataLoader = RemoteSearchImageDataLoader(client: self.httpClient)

        self.window = window
        
        let mainSearchViewController = SearchUIComposer.searchComposedWith(
        searchLoader: SearchLoaderWithFallbackComposite(
            primary: SearchLoaderCacheDecorator(
                decoratee: remoteSearchLoader,
                searchCache: inMemorySearchChace),
            fallback: localSearchLoader))
        
        mainSearchViewController.onViewWillAppear {
            self.analytics.sendMark(text: "MainSearchViewController ViewWillAppear")
        }
            
        let navigationController = UINavigationController(
            rootViewController: mainSearchViewController
        )
        
        mainSearchViewController.detailsViewNavigation = { song in
            
            self.analytics.sendMark(text: "Item selected \(song.trackId)")
            
            let detailsViewController = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
            detailsViewController.song = song
            detailsViewController.searchImageDataLoader = remoteSearchImageDataLoader
            navigationController.pushViewController(detailsViewController, animated: true)
            
            detailsViewController.onViewWillAppear {
                self.analytics.sendMark(text: "DetailsViewController ViewWillAppear")
            }
        }
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

