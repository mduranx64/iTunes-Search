//
//  RemoteSearchLoader.swift
//  iTunesSearch
//
//  Created by Miguel Duran on 01-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation

public struct Song: Codable {
    public let trackID: Int
    public let artistName: String
    public let collectionName: String
    public let trackName: String
    public let previewURL: String
    public let artworkUrl100: String

    public init(
        trackID: Int,
        artistName: String,
        collectionName: String,
        trackName: String,
        previewURL: String,
        artworkUrl100: String) {
        self.trackID = trackID
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
    }
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func load(from url: URL, completion: @escaping (SearchLoader.Result) -> Void) {
        client.get(from: url) { result in
            completion(.failure(Error.connectivity))
        }
    }

}
