//
//  SearchLoaderCacheDecorator.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation

public final class SearchLoaderCacheDecorator: SearchLoader {
    private let decoratee: SearchLoader
    private let searchCache: SearchCache
    
    public init(decoratee: SearchLoader, searchCache: SearchCache) {
        self.decoratee = decoratee
        self.searchCache = searchCache
    }
    
    public func load(from url: URL, completion: @escaping (SearchLoader.Result) -> Void) {
        decoratee.load(from: url) { [weak self] result in
            completion(result.map { songs in
                
                self?.searchCache.save(songs: songs, for: url) { _ in }
                return songs
            })
        }
    }
}
