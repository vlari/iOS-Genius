//
//  UtilManager.swift
//  LyricsApp
//
//  Created by Obed Garcia on 23/11/21.
//

import Foundation
import UIKit
import SwiftSoup

class UtilManager {
    static let shared = UtilManager()
    private init() { }
    
    // MARK: - Add your Genius API Key here
    let apiKey = ""
    
    func getNavigationAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.theme.primary
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        return appearance
    }
    
    func getFormatted(lyrics: String) -> String{
        let startPattern = "\\["
        let endPattern = "\\]"
        let startPatternResult = lyrics.replacingOccurrences(of: startPattern, with: "\n\n[", options: .regularExpression, range: nil)
        let endPatternResult = startPatternResult.replacingOccurrences(of: endPattern, with: "]\n", options: .regularExpression, range: nil)
        return endPatternResult
    }
    
    func parseHTML(from htmlString: String) -> String {
        do {
            let cleanText: String = try SwiftSoup.parse(htmlString).text()

            return cleanText
        } catch {
            return "Error html parse"
        }
    }
    
    func extrachLyrics(from stringHtml: String) -> String {
        do {
            guard let body = getHtmlBody(from: stringHtml) else {
                return ""
            }
            
            let rawLyrics = try body.select("#lyrics-root").text()
            let lyrics = UtilManager.shared.getFormatted(lyrics: rawLyrics)
            
            return lyrics
        } catch {
            return ""
        }
    }
    
    func getCharts(from stringHtml: String) -> [ChartCellViewModel] {
        do {
            guard let body = getHtmlBody(from: stringHtml) else {
                return [ChartCellViewModel]()
            }
            
            let topDiv: Elements = try body.select("#top-songs")
            let divContent: Elements = try topDiv.select("a")
            
            var charts: [ChartCellViewModel] = []
            
            for section: Element in divContent.array() {
        
                let rank = try section.select("[class*=\"Rank\"]").text()
                let titleContainer: Elements = try section.select("[class*=\"TitleAndLyrics\"]")
                let songTitle = try titleContainer.select("div").first()!.text()
                let thumbnail = try section.select("img").attr("src")
                let artist = try section.select("[class*=\"Artist\"]").text()
                
                let chart = ChartCellViewModel(rank: rank,
                                               thumbnail: thumbnail,
                                               songTitle: songTitle,
                                               artist: artist)
                
                charts.append(chart)
            }
            
            return charts
        } catch {
            return [ChartCellViewModel]()
        }
    }
    
    private func getHtmlBody(from stringHtml: String) -> Elements? {
        do {
            let doc: Document = try SwiftSoup.parse(stringHtml)
            let body: Elements = try doc.select("body")
            return body
        } catch {
            return nil
        }
    }
    
    
    
    
}
