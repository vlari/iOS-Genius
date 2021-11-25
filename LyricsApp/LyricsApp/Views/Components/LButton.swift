//
//  LButton.swift
//  LyricsApp
//
//  Created by Obed Garcia on 23/11/21.
//

import UIKit

class LButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius = 0
        backgroundColor = UIColor.black
    }
}
