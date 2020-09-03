//
//  DetailsViewController.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public final class DetailsViewController: UIViewController {
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    
    public var song: Song?
    
    public var searchImageDataLoader: SearchImageDataLoader?
    
    private var player: AVPlayer?
    
    @IBAction func playSong(_ sender: UIButton)
    {
        if let song = song, let url = URL(string: song.previewURL) {
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            player?.play()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapSong(song)
        fetchImage()
    }
    
    private func mapSong(_ song: Song?) {
        self.artistName.text = song?.artistName
        self.albumName.text = song?.collectionName
        self.songName.text = song?.trackName
    }
    
    private func fetchImage() {
        guard let song = song, let artworkUrl = URL(string: song.artworkUrl100) else { return }
        searchImageDataLoader?.loadImageData(from: artworkUrl) { [weak self] result  in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.artworkImage.image = image
                }
            case .failure:
                break
            }
        }
    }
}

