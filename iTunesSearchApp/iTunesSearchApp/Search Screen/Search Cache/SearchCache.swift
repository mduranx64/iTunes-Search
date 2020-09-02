//
//  SearchCache.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation

public protocol SearchCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ songs: [Song], completion: @escaping (Result) -> Void)
}
