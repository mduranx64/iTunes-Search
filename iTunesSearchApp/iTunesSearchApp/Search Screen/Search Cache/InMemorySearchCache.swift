//
//  InMemorySearchCache.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation
import SearchFeature

public final class InMemorySearchChace: SearchCache {
    
    private var songs = [URL: [Song]]()

    public func save(songs: [Song], for url: URL, completion: @escaping (SaveResult) -> Void) {
        self.songs[url] = songs
        completion(.success(()))
    }
    
    public func retrieve(from url: URL, completion: @escaping (RetrieveResult) -> Void) {
        completion(.success(songs[url] ?? []))
    }
}
