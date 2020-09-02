//
//  SearchUIComposer.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation
import UIKit

public final class SearchUIComposer {
    private init(){}
    
    public static func searchComposedWith(searchLoader: SearchLoader) -> MainSearchViewController {
        let presentationAdapter = SearchLoaderPresentacionAdapter(searchLoader: searchLoader)
        
        let mainSearchViewController = MainSearchViewController(
            delegate: presentationAdapter,
            tableView: UITableView.makeSearchTableView(),
            dataSource: MainSearchDataSourse()
        )
        
        presentationAdapter.presenter = SearchPresenter(searchView: mainSearchViewController)
        
        return mainSearchViewController
    }
}
