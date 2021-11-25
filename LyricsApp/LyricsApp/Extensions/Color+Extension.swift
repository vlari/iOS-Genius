//
//  Color+Extension.swift
//  LyricsApp
//
//  Created by Obed Garcia on 14/11/21.
//

import Foundation
import UIKit

extension UIColor {
    static let theme = MainTheme()
}

struct MainTheme {
    let primary = UIColor(named: "primary")
    let secondary = UIColor(named: "secondary")
    let accent = UIColor(named: "accent")
}
