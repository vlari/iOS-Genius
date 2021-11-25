//
//  SearchLyricCollectionViewCell.swift
//  LyricsApp
//
//  Created by Obed Garcia on 23/11/21.
//

import UIKit
import SDWebImage

class SearchLyricCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: SearchLyricCollectionViewCell.self)
    private let songImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 0
        return imageView
    }()
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.minimumScaleFactor = 0.10
        label.textColor = .label
        label.numberOfLines = 2
        label.font = UIFont(name: CustomFont.regular.apply, size: 18)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private let artistLabel: UILabel = {
       let label = UILabel()
        label.minimumScaleFactor = 0.10
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont(name: CustomFont.regular.apply, size: 14)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.systemBackground
        contentView.addSubview(songImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        songImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            songImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            songImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            songImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            songImageView.widthAnchor.constraint(equalTo: songImageView.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            artistLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 8),
            artistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with viewModel: SearchLyricCellViewModel) {
        songImageView.sd_setImage(with: URL(string: viewModel.songThumbnail), completed: nil)
        titleLabel.text = viewModel.title
        artistLabel.text = viewModel.artistName
    }
}
