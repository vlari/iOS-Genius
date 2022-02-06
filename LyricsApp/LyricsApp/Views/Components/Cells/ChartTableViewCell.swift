//
//  ChartTableViewCell.swift
//  LyricsApp
//
//  Created by Obed Garcia on 5/2/22.
//

import UIKit

class ChartTableViewCell: UITableViewCell {
    static let identifier = String(describing: ChartTableViewCell.self)
    let rankLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .title2)
        view.textColor = UIColor.theme.accent
        view.adjustsFontForContentSizeCategory = true
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return view
    }()
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
    let descriptionStackView = UIStackView()
    let songDetailStackView = UIStackView()
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
    
    func configure(with viewModel: ChartCellViewModel) {
        self.rankLabel.text = viewModel.rank
        self.songTitleLabel.text = viewModel.songTitle
        self.artistLabel.text = viewModel.artist
    }
    
    private func configureViews() {
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        baseStackView.axis = .vertical
        baseStackView.spacing = 6
        
        songDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        songDetailStackView.axis = .vertical
        songDetailStackView.addArrangedSubview(songTitleLabel)
        songDetailStackView.addArrangedSubview(artistLabel)
        
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        descriptionStackView.axis = .horizontal
        descriptionStackView.alignment = .leading
        descriptionStackView.spacing = 4
        descriptionStackView.addArrangedSubview(rankLabel)
        descriptionStackView.addArrangedSubview(songDetailStackView)
        
        cellDivider.translatesAutoresizingMaskIntoConstraints = false
        cellDivider.backgroundColor = .black
        
        baseStackView.addArrangedSubview(descriptionStackView)
        baseStackView.addArrangedSubview(cellDivider)
    }
    
    private func configureLayout() {
        contentView.addSubview(baseStackView)
        
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            baseStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: baseStackView.trailingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: baseStackView.bottomAnchor, multiplier: 2)
        ])
        
        cellDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
