//
//  ITunesRemoteResult.swift
//  iTunesSearch
//
//  Created by Miguel Duran on 28-08-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation

// MARK: - ITunesResult
struct ITunesRemoteResult: Codable {
    public let resultCount: Int
    public let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    public let trackID: Int
    public let artistName: String
    public let collectionName: String
    public let trackName: String
    public let previewURL: String
    public let artworkUrl100: String

    enum CodingKeys: String, CodingKey {
        case trackID = "trackId"
        case artistName
        case collectionName
        case trackName
        case previewURL = "previewUrl"
        case artworkUrl100
    }
}
