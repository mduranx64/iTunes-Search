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
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        messages.append((url, completion))
        return Task()
    }

}

class LoadSearchFromRemoteUseCaseTests: XCTestCase {

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://test-url.com")!
        let (sut, client) = makeSUT()
        
        sut.load(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwoTimes() {
        let url = URL(string: "https://test-url.com")!
        let (sut, client) = makeSUT()
        
        sut.load(from: url) { _ in }
        sut.load(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])

    }

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteSearchLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteSearchLoader(client: client)
        return (sut, client)
    }
}
