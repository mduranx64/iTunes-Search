//
//  SearchLoaderPresentacionAdapter.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation

final class SearchLoaderPresentacionAdapter: MainSearchViewControllerDelegate {
    private let searchLoader: SearchLoader
    var presenter: SearchPresenter?
    
    init(searchLoader: SearchLoader) {
        self.searchLoader = searchLoader
    }
    
    func didRequestSearchWith(_ text: String?) {
        guard let text = text else { return }
        let urlString = "https://itunes.apple.com/search?mediaType=music&limit=20&term=\(text)"
        guard let url = URL(string: urlString) else { return }
        searchLoader.load(from: url) { [weak self] result in
            switch result {
            case let .success(songs):
                DispatchQueue.main.async {
                    self?.presenter?.didFinishSearchLoading(with: songs)
                }
            case .failure(_):
                break
            }
        }
    }

}
