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
}
