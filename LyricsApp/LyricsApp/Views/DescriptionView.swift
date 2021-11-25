//
//  DescriptionView.swift
//  LyricsApp
//
//  Created by Obed Garcia on 25/11/21.
//

import UIKit

class DescriptionView: UIView {
    let descriptionLabel: UILabel = {
       let label = UILabel()
        label.minimumScaleFactor = 0.10
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: CustomFont.regular.apply, size: 18)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descriptionTitleLabel: UILabel = {
       let label = UILabel()
        label.minimumScaleFactor = 0.10
        label.textColor = .black
        label.font = UIFont(name: CustomFont.regular.apply, size: 24)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var scrollView: UIScrollView = {
      let scrollView = UIScrollView()
      scrollView.backgroundColor = .systemBackground
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      return scrollView
    }()
    private lazy var scrollContentView: UIView = {
      let contentView = UIView()
      contentView.backgroundColor = .systemBackground
      contentView.translatesAutoresizingMaskIntoConstraints = false
      return contentView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.descriptionTitleLabel.text = title
        configure()
    }
    
    private func configure() {
        addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(descriptionTitleLabel)
        scrollContentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            descriptionTitleLabel.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 20),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            descriptionTitleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor)
        ])
    }
}
