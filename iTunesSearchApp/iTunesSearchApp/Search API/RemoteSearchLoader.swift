//
//  RemoteSearchLoader.swift
//  iTunesSearch
//
//  Created by Miguel Duran on 01-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation

public final class RemoteSearchLoader: SearchLoader {
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func load(from url: URL, completion: @escaping (SearchLoader.Result) -> Void) {
        client.get(from: url) { result in
            
            switch result {
            case let .success((data, response)):
                completion(RemoteSearchLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> SearchLoader.Result {
        do {
            let items = try SearchItemsMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == Result {
    func toModels() -> [Song] {
        return map {
            Song(
                trackId: $0.trackId,
                artistName: $0.artistName,
                collectionName: $0.collectionName,
                trackName: $0.trackName,
                previewURL: $0.previewUrl,
                artworkUrl100: $0.artworkUrl100
            )
        }
    }
}
