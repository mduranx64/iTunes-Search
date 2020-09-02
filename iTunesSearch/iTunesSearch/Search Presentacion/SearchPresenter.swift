//
//  SearchPresenter.swift
//  iTunesSearch
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation

public protocol SearchView {
    func display(_ viewModel: SearchViewModel)
    func search(_ text: String)
}

public final class SearchPresenter {
    private let searchView: SearchView
    
    public init(searchView: SearchView) {
        self.searchView = searchView
    }
}
