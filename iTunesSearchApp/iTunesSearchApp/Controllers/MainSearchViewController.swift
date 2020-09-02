//
//  MainSearchViewController.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation
import UIKit

protocol MainSearchViewControllerDelegate {
    func didRequestSearchWith(_ text: String?)
}

class MainSearchViewController: UIViewController {

    private let tableView: UITableView
    private let dataSource: MainSearchDataSourse
    private let searchController = UISearchController(searchResultsController: nil)
    private let delegate: MainSearchViewControllerDelegate
    
    init(delegate: MainSearchViewControllerDelegate, tableView: UITableView, dataSource: MainSearchDataSourse) {
        self.tableView = tableView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.tableView.dataSource = dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Songs"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        self.view = tableView
    }
    
}

extension MainSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        delegate.didRequestSearchWith(text)
    }
}

extension MainSearchViewController: SearchView {
    func display(_ viewModel: SearchViewModel) {
        dataSource.update(viewModel.songs)
        tableView.reloadData()
    }
}
