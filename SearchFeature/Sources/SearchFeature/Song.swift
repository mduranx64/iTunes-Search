//
//  Song.swift
//  iTunesSearch
//
//  Created by Miguel Duran on 02-09-20.
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
        self.artworkUrl100 = artworkUrl100
    }
}
