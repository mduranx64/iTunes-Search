//
//  File.swift
//  
//
//  Created by Miguel Duran on 12-11-20.
//

import XCTest
import SearchFeature
@testable import SearchCache

final class SearchCacheTests: XCTestCase {
    func testExample() {
        
        let sut = InMemorySearchChace()
        let song1 = Song(trackId: 0, artistName: "adele", collectionName: "21", trackName: "hello", previewURL: "http://some-url.com", artworkUrl100: "http://some-url.com")
        let song2 = Song(trackId: 1, artistName: "adele", collectionName: "21", trackName: "hello", previewURL: "http://some-url.com", artworkUrl100: "http://some-url.com")
        
        let saveURL1 = URL(string: "http://save-url1.com")!
        let saveURL2 = URL(string: "http://save-url2.com")!

        sut.save(songs: [song1], for: saveURL1) { _ in  }
        sut.save(songs: [song2], for: saveURL2) { _ in  }

        sut.retrieve(from: saveURL1) { retrieveResult in
            switch retrieveResult {
            case .success(let savedSongs):
                XCTAssertEqual(savedSongs.count, 1)
            case .failure:
                XCTFail()
            }
        }
        
        sut.retrieve(from: saveURL2) { retrieveResult in
            switch retrieveResult {
            case .success(let savedSongs):
                XCTAssertEqual(savedSongs.count, 1)
            case .failure:
                XCTFail()
            }
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

