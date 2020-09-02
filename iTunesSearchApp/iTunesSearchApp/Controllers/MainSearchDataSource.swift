//
//  MainSearchDataSource.swift
//  iTunesSearchApp
//
//  Created by Miguel Duran on 02-09-20.
//  Copyright © 2020 Miguel Duran. All rights reserved.
//

import Foundation
import UIKit

class MainSearchDataSourse: NSObject {
    
    private var songs = [Song]()
    
    func update(_ songs: [Song]) {
        self.songs = songs
    }
}

extension MainSearchDataSourse: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let song = songs[indexPath.row]
        cell.textLabel?.text = "\(song.trackName)"
    
        return cell
    }
}
