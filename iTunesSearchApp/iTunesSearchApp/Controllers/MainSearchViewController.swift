//
//  MainSearchViewController.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation

import UIKit

class MainSearchViewController: UIViewController {

    private var tableView: UITableView
    private var dataSource: UITableViewDataSource
    
    init(tableView: UITableView, dataSource: UITableViewDataSource) {
        self.tableView = tableView
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
        self.view = tableView
        self.tableView.dataSource = dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
