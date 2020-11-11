//
//  SearchLoaderWithFallbackComposite.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation
import SearchFeature

public class SearchLoaderWithFallbackComposite: SearchLoader {
    
    private let primary: SearchLoader
    private let fallback: SearchLoader
    
    public init(primary: SearchLoader, fallback: SearchLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func load(from url: URL, completion: @escaping (SearchLoader.Result) -> Void) {
        primary.load(from: url) { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                self?.fallback.load(from: url, completion: completion)
            }
        }
    }
}
