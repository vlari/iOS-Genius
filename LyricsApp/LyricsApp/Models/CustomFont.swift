//
//  CustomFont.swift
//  LyricsApp
//
//  Created by Obed Garcia on 23/11/21.
//

import Foundation

enum CustomFont {
    case regular
    
    var apply: String {
        switch self {
        case .regular:
            return "Programme-Regular"
        }
    }
}
