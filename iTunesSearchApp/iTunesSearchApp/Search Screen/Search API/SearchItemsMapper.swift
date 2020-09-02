//
//  SearchItemsMapper.swift
//  iTunesSearch
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation

final class SearchItemsMapper {
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Result] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        guard response.statusCode == 200 else { throw RemoteSearchLoader.Error.invalidData }
        let itunesResult = try decoder.decode(ITunesRemoteResult.self, from: data)
        
        return itunesResult.results
    }
}
