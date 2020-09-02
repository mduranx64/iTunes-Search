//
//  LocalSearchLoader.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation

public final class LocalSearchLoader: SearchLoader {
  
    private let searchCache: SearchCache
    
    public init(searchCache: SearchCache) {
        self.searchCache = searchCache
    }
 
    public func load(from url: URL, completion: @escaping (SearchLoader.Result) -> Void) {
        searchCache.retrieve(from: url) { result in
            switch result {
            case let .success(songs):
                completion(.success(songs))
            case .failure:
                break
            }
        }
    }
}
