//
//  ApiService.swift
//  LyricsApp
//
//  Created by Obed Garcia on 22/11/21.
//

import Foundation
import SwiftSoup

class ApiService {
    static let shared = ApiService()
    private init() {}
    
    func request<T: Codable>(endpoint: ApiEndpoint, completion: @escaping (Result<T, Error>) -> ()) {
        let urlComponents = getUrlComponents(from: endpoint)
        
        guard let url = urlComponents.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "Api service error")
                return
            }
            guard response != nil,
                  let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                if let dataResponse = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(dataResponse))
                } else {
                    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "JSON decode failure"])
                    completion(.failure(error))
                }
            }
        }
        
        dataTask.resume()
    }
    
    
    func request(endpoint: ApiEndpoint, completion: @escaping (Result<String, Error>) -> ()) {
        let urlComponents = getUrlComponents(from: endpoint)
        
        guard let url = urlComponents.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "Api service error")
                return
            }
            guard response != nil,
                  let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                let stringHtml = String(data: data, encoding: .utf8)!
                
                do {
                    let doc: Document = try SwiftSoup.parse(stringHtml)
                    let body: Elements = try doc.select("body")
                    let lyricContainer: Elements = try body.select(".song_body-lyrics")
                    let rawLyrics: String = try lyricContainer.select(".lyrics").text()
                    
                    let lyrics = UtilManager.shared.getFormatted(lyrics: rawLyrics)
                    
                    completion(.success(lyrics))
                } catch {
                    completion(.failure(APIError.failedHtmlParsing))
                }
            }
        }
        
        dataTask.resume()
    }
    
    private func getUrlComponents(from endpoint: ApiEndpoint) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.baseURL
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.parameters
        
        return urlComponents
    }
}

enum APIError: Error {
    case failedResponseData
    case failedHtmlParsing
}
