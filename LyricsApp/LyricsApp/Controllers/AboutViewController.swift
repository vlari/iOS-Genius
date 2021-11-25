//
//  AboutViewController.swift
//  LyricsApp
//
//  Created by Obed Garcia on 24/11/21.
//

import UIKit

class AboutViewController: UIViewController {
    private let songData: SongViewModel
    var albumDetailView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let albumImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let albumTemplateLabel: UILabel = {
       let label = UILabel()
        label.minimumScaleFactor = 0.10
        label.textColor = UIColor.theme.accent
        label.text = "Album"
        label.font = UIFont(name: CustomFont.regular.apply, size: 22)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let albumTitleLabel: UILabel = {
       let label = UILabel()
        label.minimumScaleFactor = 0.10
        label.text = ""
        label.textColor = UIColor.black
        label.font = UIFont(name: CustomFont.regular.apply, size: 18)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let albumDateTemplateLabel: UILabel = {
       let label = UILabel()
        label.minimumScaleFactor = 0.10
        label.textColor = UIColor.theme.accent
        label.text = "Release Date"
        label.font = UIFont(name: CustomFont.regular.apply, size: 22)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let albumDateLabel: UILabel = {
       let label = UILabel()
        label.minimumScaleFactor = 0.10
        label.text = ""
        label.textColor = UIColor.black
        label.font = UIFont(name: CustomFont.regular.apply, size: 18)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var descriptionView: DescriptionView = DescriptionView(title: "Description")
    
    init(songData: SongViewModel) {
        self.songData = songData
        self.albumDateLabel.text = songData.releaseDate
        self.descriptionView.descriptionLabel.text = songData.description
        
        if let album = songData.album {
            self.albumTitleLabel.text = album.name
            albumImageView.sd_setImage(with: URL(string: album.albumImage), completed: nil)
        } else {
            albumImageView.image = UIImage(named: "iconImage")
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissButton()
        configure()
        addChildViews()
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionView)
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: albumDetailView.bottomAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "About"
        let appearance = UtilManager.shared.getNavigationAppearance()
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            albumDetailView.topAnchor.constraint(equalTo: view.topAnchor),
            albumDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            albumDetailView.heightAnchor.constraint(equalToConstant: 340)
        ])
        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: albumDetailView.safeAreaLayoutGuide.topAnchor, constant: 8),
            albumImageView.leadingAnchor.constraint(equalTo: albumDetailView.leadingAnchor, constant: 8),
            albumImageView.heightAnchor.constraint(equalToConstant: 160),
            albumImageView.widthAnchor.constraint(equalTo: albumImageView.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            albumTemplateLabel.topAnchor.constraint(equalTo: albumImageView.topAnchor, constant: 4),
            albumTemplateLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 12),
            albumTemplateLabel.trailingAnchor.constraint(equalTo: albumDetailView.trailingAnchor),
            albumTemplateLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            albumTitleLabel.topAnchor.constraint(equalTo: albumTemplateLabel.topAnchor, constant: 18),
            albumTitleLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 12),
            albumTitleLabel.trailingAnchor.constraint(equalTo: albumDetailView.trailingAnchor),
            albumTitleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            albumDateTemplateLabel.topAnchor.constraint(equalTo: albumTitleLabel.topAnchor, constant: 26),
            albumDateTemplateLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 12),
            albumDateTemplateLabel.trailingAnchor.constraint(equalTo: albumDetailView.trailingAnchor),
            albumDateTemplateLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            albumDateLabel.topAnchor.constraint(equalTo: albumDateTemplateLabel.topAnchor, constant: 18),
            albumDateLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 12),
            albumDateLabel.trailingAnchor.constraint(equalTo: albumDetailView.trailingAnchor),
            albumDateLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Methods
    private func configure() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(albumDetailView)
//        edgesForExtendedLayout = []
    }
    
    private func addChildViews() {
        albumDetailView.addSubview(albumImageView)
        albumDetailView.addSubview(albumTemplateLabel)
        albumDetailView.addSubview(albumTitleLabel)
        albumDetailView.addSubview(albumDateTemplateLabel)
        albumDetailView.addSubview(albumDateLabel)
    }
}
