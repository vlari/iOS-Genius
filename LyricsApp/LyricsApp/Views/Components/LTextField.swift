//
//  LTextField.swift
//  LyricsApp
//
//  Created by Obed Garcia on 23/11/21.
//

import UIKit

class LTextField: UITextField {
    var textPadding = UIEdgeInsets(
        top: 10,
        left: 14,
        bottom: 10,
        right: 20
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(placeHolder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .black
        tintColor = .black
        layer.borderWidth = 2
        layer.cornerRadius = 0
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = UIColor.white
        
        setLeftView()
    }
    
    private func setLeftView() {
        let searchIcon = UIImageView()
        searchIcon.frame = CGRect(x: 10, y: 4, width: 26, height: 24)
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        let iconContainerView: UIView = UIView()
        iconContainerView.frame = CGRect(x: 20, y: 0, width: 30, height: 30)
        iconContainerView.addSubview(searchIcon)
        leftViewMode = .always
        leftView = iconContainerView
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
