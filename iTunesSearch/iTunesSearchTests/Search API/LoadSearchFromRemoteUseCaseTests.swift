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

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteSearchLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteSearchLoader(client: client)
        return (sut, client)
    }
    
    private func makeTestURL() -> URL {
        return URL(string: "https://test-url.com")!
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
}
