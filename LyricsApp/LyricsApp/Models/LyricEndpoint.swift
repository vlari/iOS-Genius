//
//  LyricEndpoint.swift
//  LyricsApp
//
//  Created by Obed Garcia on 22/11/21.
//

import Foundation

enum LyricEndpoint: ApiEndpoint {
    case getSearchResult(searchText: String)
    case getSongResult(songId: String)
    case getLyrics(fromUrl: String)
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        case .getLyrics:
            return "genius.com"
        default:
            return "api.genius.com"
        }
    }
    
    var path: String {
        switch self {
        case .getSearchResult:
            return "/search"
        case .getSongResult(let songId):
            return "\(songId)"
        case .getLyrics(let fromUrl):
            return fromUrl
        }
    }
    
    var parameters: [URLQueryItem] {
        let apiKey = UtilManager.shared.apiKey
        
        switch self {
        case .getSearchResult(let searchText):
            return [URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "access_token", value: apiKey)]
        case .getSongResult:
            return [URLQueryItem(name: "access_token", value: apiKey),
                    URLQueryItem(name: "text_format", value: "html")]
        case .getLyrics:
            return []
        }
    }
    
    var method: String {
        switch self {
        case.getSearchResult, .getSongResult, .getLyrics:
            return "GET"
        }
    }
}
