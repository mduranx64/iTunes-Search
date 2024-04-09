//
//  SearchUIComposer.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation
import UIKit
import SearchFeature
import SearchPresentation
import SearchUI

public final class SearchUIComposer {
    private init(){}
    
    public static func searchComposedWith(searchLoader: SearchLoader) -> MainSearchViewController {
        let presentationAdapter = SearchLoaderPresentationAdapter(searchLoader: searchLoader)
        
        let mainSearchViewController = MainSearchViewController(
            delegate: presentationAdapter,
            tableView: UITableView.makeSearchTableView(),
            dataSource: MainSearchDataSource()
        )
        mainSearchViewController.title = "iTunes Search"
        
        presentationAdapter.presenter = SearchPresenter(searchView: mainSearchViewController)
        
        return mainSearchViewController
    }
}
