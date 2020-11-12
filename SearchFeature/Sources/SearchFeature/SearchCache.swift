//
//  SearchCache.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation

public protocol SearchCache {
    typealias SaveResult = Swift.Result<Void, Error>
    typealias RetrieveResult = Swift.Result<[Song], Error>
    
    func save(songs: [Song], for url: URL, completion: @escaping (SaveResult) -> Void)
    
    func retrieve(from url: URL, completion: @escaping (RetrieveResult) -> Void)
}
