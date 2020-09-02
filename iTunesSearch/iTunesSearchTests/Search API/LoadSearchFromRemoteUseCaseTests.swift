//
//  LoadSearchFromRemoteUseCaseTests.swift
//  iTunesSearchTests
//
//  Created by Miguel Duran on 01-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import XCTest
import iTunesSearch

class HTTPClientSpy: HTTPClient {
    
    private struct Task: HTTPClientTask {
        func cancel() {
            
        }
    }
    
    private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index].completion(.success((data, response)))
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        messages.append((url, completion))
        return Task()
    }

}

class LoadSearchFromRemoteUseCaseTests: XCTestCase {

    func test_load_requestsDataFromURL() {
        let url = makeTestURL()
        let (sut, client) = makeSUT()
        
        sut.load(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwoTimes() {
        let url = makeTestURL()
        let (sut, client) = makeSUT()
        
        sut.load(from: url) { _ in }
        sut.load(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])

    }
    
    func test_load_deliversErrorOnClientError() {
        let url = makeTestURL()
        let (sut, client) = makeSUT()

        expect(from: url, sut: sut, toCompleteWith: .failure(RemoteSearchLoader.Error.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorWhenHTTPResonseIsNot200() {
        let (sut, client) = makeSUT()

        let codes = [300, 400, 500]
        
        codes.enumerated().forEach { index, code in
            expect(from: makeTestURL(), sut: sut, toCompleteWith: .failure(RemoteSearchLoader.Error.invalidData), when: {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorWhenHTTPResponseIsAnInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(from: makeTestURL(), sut: sut, toCompleteWith: .failure(RemoteSearchLoader.Error.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversEmptyItemsWhenEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(from: makeTestURL(), sut: sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversSongsWhenResponseWithJSONItems() {
        let (sut, client) = makeSUT()

        let song1 = makeSong(
            trackId: 111,
            artistName: "Adele",
            collectionName: "19",
            trackName: "Tired",
            previewURL: makeTestURL(path:"preview").absoluteString,
            artworkUrl100: makeTestURL(path: "artwork").absoluteString
        )
        
        let song2 = makeSong(
            trackId: 111,
            artistName: "Adele",
            collectionName: "19",
            trackName: "My Same",
            previewURL: makeTestURL(path:"preview").absoluteString,
            artworkUrl100: makeTestURL(path: "artwork").absoluteString
        )
        
        let songs = [song1.model, song2.model]
        
        expect(from: makeTestURL(), sut: sut, toCompleteWith: .success(songs), when: {
            let json = makeItemsJSON([song1.json, song2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteSearchLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteSearchLoader(client: client)
        return (sut, client)
    }
    
    private func makeTestURL(path: String = "") -> URL {
        let url = URL(string: "https://test-url.com")!
        return path.isEmpty ? url.appendingPathComponent(path) : url
    }
    
    private func expect(from url: URL, sut: RemoteSearchLoader, toCompleteWith expectedResult: RemoteSearchLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load(from: url) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.failure(receivedError as RemoteSearchLoader.Error),
                      .failure(expectedError as RemoteSearchLoader.Error)):
                
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            case (_, _):
                break
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makeSong(
        trackId: Int,
        artistName: String,
        collectionName: String,
        trackName: String,
        previewURL: String,
        artworkUrl100: String) -> (model: Song, json: [String: Any])
    {
        let song = Song(
            trackId: trackId,
            artistName: artistName,
            collectionName: collectionName,
            trackName: trackName,
            previewURL: previewURL,
            artworkUrl100: artworkUrl100
        )
        
        let json = [
            "trackId": trackName,
            "artistName": artistName,
            "collectionName": collectionName,
            "trackName": trackName,
            "previewURL": previewURL,
            "artworkUrl100": artworkUrl100
        ].compactMapValues { $0 }
        
        return (song, json)
    }
}
