//
//  RemoteSearchLoader.swift
//  iTunesSearch
//
//  Created by Miguel Duran on 01-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation

public struct Song: Codable {
    public let trackId: Int
    public let artistName: String
    public let collectionName: String
    public let trackName: String
    public let previewURL: String
    public let artworkUrl100: String

    public init(
        trackId: Int,
        artistName: String,
        collectionName: String,
        trackName: String,
        previewURL: String,
        artworkUrl100: String) {
        self.trackId = trackId
        self.artistName = artistName
        self.collectionName = collectionName
        self.trackName = trackName
        self.previewURL = previewURL
        self.artworkUrl100 = previewURL
    }
}

public protocol SearchLoader {
    typealias Result = Swift.Result<[Song], Error>
    
    func load(from url: URL, completion: @escaping (Result) -> Void)
}

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
                previewURL: $0.previewURL,
                artworkUrl100: $0.artworkUrl100
            )
        }
    }
}

final class SearchItemsMapper {
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Result] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        guard response.statusCode == 200, let itunesResult = try? decoder.decode(ITunesRemoteResult.self, from: data) else {
            throw RemoteSearchLoader.Error.invalidData
        }
        
        return itunesResult.results
    }
}
