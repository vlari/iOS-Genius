//
//  BookmarkLyricTableViewCell.swift
//  LyricsApp
//
//  Created by Obed Garcia on 6/2/22.
//

import UIKit

class BookmarkLyricTableViewCell: UITableViewCell {
    static let identifier = String(describing: BookmarkLyricTableViewCell.self)
    let songTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .title2)
        view.adjustsFontForContentSizeCategory = true
        return view
    }()
    let artistLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.textColor = UIColor.systemGray
        view.adjustsFontForContentSizeCategory = true
        return view
    }()
    let baseStackView = UIStackView()
    let contentStackView = UIStackView()
    let cellDivider = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: BookmarkedLyricCellViewModel) {
        self.songTitleLabel.text = viewModel.songTitle
        self.artistLabel.text = viewModel.artist
    }
    
    private func configureViews() {
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        baseStackView.axis = .vertical
        baseStackView.spacing = 6
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        
        cellDivider.translatesAutoresizingMaskIntoConstraints = false
        cellDivider.backgroundColor = .black
        
        contentStackView.addArrangedSubview(songTitleLabel)
        contentStackView.addArrangedSubview(artistLabel)
        
        baseStackView.addArrangedSubview(contentStackView)
        baseStackView.addArrangedSubview(cellDivider)
    }
    
    private func configureLayout() {
        contentView.addSubview(baseStackView)
        
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            baseStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: baseStackView.trailingAnchor, multiplier: 2),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: baseStackView.bottomAnchor, multiplier: 2)
        ])
        
        cellDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
