//
//  LoadingView.swift
//  LyricsApp
//
//  Created by Obed Garcia on 25/11/21.
//

import UIKit
import Lottie

class LoadingView: UIView {
    var animationView: AnimationView = AnimationView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    private func configure() {
        animationView = AnimationView.init(name: "loader")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 80),
            animationView.topAnchor.constraint(equalTo: self.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        animationView.play()
    }
}
