//
//  UITableView+Configuration.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    static func makeSearchTableView() -> UITableView {
        let tableView = UITableView()
        tableView.registerCell(with: UITableViewCell.self)
        return tableView
    }
}
