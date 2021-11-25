//
//  SongResponse.swift
//  LyricsApp
//
//  Created by Obed Garcia on 23/11/21.
//

import Foundation

struct SongResponse: Codable {
    let response: SongResult
}

struct SongResult: Codable {
    let song: Song
}

struct Song: Codable {
    let stats: SongStatistic
    let album: Album?
    let releaseDate: String?
    let path: String
    let description: DescriptionResult?
    
    enum CodingKeys: String, CodingKey {
        case stats
        case album
        case releaseDate = "release_date_for_display"
        case path
        case description
    }
}

struct SongStatistic: Codable {
    let pageviews: Int?
}

struct Album: Codable {
    let name: String
    let albumImage: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case albumImage = "cover_art_url"
    }
}

struct DescriptionResult: Codable {
    let html: String
}
