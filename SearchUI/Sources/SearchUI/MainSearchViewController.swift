//
//  MainSearchViewController.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation
import UIKit
import SearchFeature
import SearchPresentacion

@available(iOS 11.0, *)
public protocol MainSearchViewControllerDelegate {
    func didRequestSearchWith(_ text: String?)
}

@available(iOS 11.0, *)
public class MainSearchViewController: UIViewController {

    private let tableView: UITableView
    private let dataSource: MainSearchDataSourse
    private let searchController = UISearchController(searchResultsController: nil)
    private let delegate: MainSearchViewControllerDelegate
    
    public var detailsViewNavigation: ((Song) -> ())?
    
    public init(delegate: MainSearchViewControllerDelegate, tableView: UITableView, dataSource: MainSearchDataSourse) {
        self.tableView = tableView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.tableView.dataSource = dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Songs"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        self.view = tableView
        self.tableView.delegate = self
    }
    
}

@available(iOS 11.0, *)
extension MainSearchViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        delegate.didRequestSearchWith(text)
    }
}

@available(iOS 11.0, *)
extension MainSearchViewController: SearchView {
    public func display(_ viewModel: SearchViewModel) {
        dataSource.update(viewModel.songs)
        tableView.reloadData()
    }
}

@available(iOS 11.0, *)
extension MainSearchViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = dataSource.item(at: indexPath.row)
        self.detailsViewNavigation?(song)
    }
}
