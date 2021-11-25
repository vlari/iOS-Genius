//
//  ApiEndpoint.swift
//  LyricsApp
//
//  Created by Obed Garcia on 22/11/21.
//

import Foundation

protocol ApiEndpoint {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: String { get }
}
