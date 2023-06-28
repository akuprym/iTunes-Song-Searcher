//
//  SearchResponse.swift
//  Soundly
//
//  Created by admin on 27.06.23.
//

import Foundation

class SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var artistName: String
    var collectionName: String?
    var artworkUrl60: String?
}
