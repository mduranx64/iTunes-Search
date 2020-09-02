//
//  SearchLoader.swift
//  iTunesSearch
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation

public protocol SearchLoader {
    typealias Result = Swift.Result<[Song], Error>
    
    func load(from url: URL, completion: @escaping (Result) -> Void)
}
