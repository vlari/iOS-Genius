//
//  SearchResponse.swift
//  LyricsApp
//
//  Created by Obed Garcia on 22/11/21.
//

import Foundation

struct SearcResponse: Codable {
    let response: SearchHit
}

struct SearchHit: Codable {
    let hits: [LyricHit]
}

struct LyricHit: Codable {
    let index: String
    let type: String
    let result: SearchResult
}

struct SearchResult: Codable {
    let id: Int
    let url: String
    let path: String
    let title: String
    let apiPath : String
    let artistNames: String
    let fullTitle: String
    let songImage: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case path
        case title
        case apiPath = "api_path"
        case artistNames = "artist_names"
        case fullTitle = "full_title"
        case songImage = "song_art_image_thumbnail_url"
    }
}
