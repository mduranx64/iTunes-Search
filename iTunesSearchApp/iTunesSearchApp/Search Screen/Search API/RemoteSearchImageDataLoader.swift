//
//  RemoteSearchImageDataLoader.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation

public final class RemoteSearchImageDataLoader: SearchImageDataLoader {

    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadImageData(from url: URL, completion: @escaping (SearchImageDataLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, _)):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
