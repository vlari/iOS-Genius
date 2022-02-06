//
//  SiteEndpoint.swift
//  LyricsApp
//
//  Created by Obed Garcia on 4/2/22.
//

import Foundation

enum SiteEndpoint: ApiEndpoint {
    case getCharts
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        case .getCharts:
            return "genius.com"
        }
    }
    
    var path: String {
        switch self {
        case .getCharts:
            return ""
        }
    }
    
    var parameters: [URLQueryItem] {
    
        switch self {
        case .getCharts:
            return []
        }
    }
    
    var method: String {
        switch self {
        case .getCharts:
            return "GET"
        }
    }
}
