//
//  LyricViewController.swift
//  LyricsApp
//
//  Created by Obed Garcia on 23/11/21.
//

import UIKit

class LyricViewController: UIViewController {
    private let lyricData: SearchLyricCellViewModel
    private let songImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.minimumScaleFactor = 0.10
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: CustomFont.regular.apply, size: 18)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let artistLabel: UILabel = {
       let label = UILabel()
        label.minimumScaleFactor = 0.10
        label.textColor = .label
        label.numberOfLines = 1
        label.font = UIFont(name: CustomFont.regular.apply, size: 18)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let viewsImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "eye")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.black
        return imageView
    }()
    private let viewsLabel: UILabel = {
       let label = UILabel()
        label.minimumScaleFactor = 0.10
        label.textColor = .label
        label.numberOfLines = 1
        label.font = UIFont(name: CustomFont.regular.apply, size: 14)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.theme.accent
        return label
    }()
    var songDetailView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var aboutbutton: LButton = {
        let button = LButton(title: "About")
        return button
    }()
    private var lyrics: String = ""
    private var descriptionView: DescriptionView = DescriptionView(title: "Lyrics")
    private var songViewModel: SongViewModel?
    private let bookmarkLyricViewModel = BookedmarkLyricViewModel()
    private var isBookmarked: Bool = false
    
    init(lyricData: SearchLyricCellViewModel) {
        self.lyricData = lyricData
        self.titleLabel.text = lyricData.title
        self.artistLabel.text = "by " + lyricData.artistName
        songImageView.sd_setImage(with: URL(string: lyricData.songThumbnail), completed: nil)
        
        super.init(nibName: nil, bundle: nil)
        self.fetchData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addChildViews()
        aboutbutton.addTarget(self, action: #selector(didTapAbout), for: .touchUpInside)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionView)
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: songDetailView.bottomAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = ""
        let appearance = UtilManager.shared.getNavigationAppearance()
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.isBookmarked = bookmarkLyricViewModel.isBookmarked(for: "\(lyricData.id)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            songDetailView.topAnchor.constraint(equalTo: view.topAnchor),
            songDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            songDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            songDetailView.heightAnchor.constraint(equalToConstant: 200)
        ])
        NSLayoutConstraint.activate([
            songImageView.topAnchor.constraint(equalTo: songDetailView.topAnchor, constant: 8),
            songImageView.leadingAnchor.constraint(equalTo: songDetailView.leadingAnchor, constant: 8),
            songImageView.heightAnchor.constraint(equalToConstant: 160),
            songImageView.widthAnchor.constraint(equalTo: songImageView.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: songDetailView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: songDetailView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            artistLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 12),
            artistLabel.trailingAnchor.constraint(equalTo: songDetailView.trailingAnchor),
            artistLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            viewsImageView.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 2),
            viewsImageView.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 12),
            viewsImageView.heightAnchor.constraint(equalToConstant: 20),
            viewsImageView.widthAnchor.constraint(equalTo: viewsImageView.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            viewsLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor),
            viewsLabel.leadingAnchor.constraint(equalTo: viewsImageView.trailingAnchor, constant: 6),
            viewsLabel.trailingAnchor.constraint(equalTo: songDetailView.trailingAnchor),
            viewsLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        NSLayoutConstraint.activate([
            aboutbutton.bottomAnchor.constraint(equalTo: songImageView.bottomAnchor),
            aboutbutton.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 12),
            aboutbutton.trailingAnchor.constraint(equalTo: songDetailView.trailingAnchor, constant: -12),
            aboutbutton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Methods
    private func configure() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        edgesForExtendedLayout = []
        view.addSubview(songDetailView)
    }
    
    @objc func didTapBookmarkButton() {
        if isBookmarked {
            let bookmark = bookmarkLyricViewModel.getExisting(by: "\(lyricData.id)")!
            
            bookmarkLyricViewModel.delete(bookmark: bookmark) { (result) in
                switch result {
                case .success(let wasDeleted):
                    print("Deleted \(wasDeleted)")
                    
                case .failure(let error):
                    print("error \(error)")
                }
            }
        } else {
            bookmarkLyricViewModel.id = "\(lyricData.id)"
            bookmarkLyricViewModel.songTitle = lyricData.title
            bookmarkLyricViewModel.artist = lyricData.artistName
            
            bookmarkLyricViewModel.save { [weak self] (result) in
                switch result {
                case .success(let isSaved):
                    print("Saved \(isSaved)")
                    self?.isBookmarked = true
                    self?.updateBookmarkButtonState()
                case .failure(let error):
                    print("Error \(error)")
                }
            }
        }
    }
    
    private func updateBookmarkButtonState() {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
    }
    
    private func addChildViews() {
        songDetailView.addSubview(songImageView)
        songDetailView.addSubview(titleLabel)
        songDetailView.addSubview(artistLabel)
        songDetailView.addSubview(viewsImageView)
        songDetailView.addSubview(viewsLabel)
        songDetailView.addSubview(aboutbutton)
    }
    
    // MARK: - Api methods
    private func fetchData() {
        ApiService.shared.request(endpoint: LyricEndpoint.getSongResult(songId: self.lyricData.apiPath)) { [weak self] (result: Result<SongResponse, Error>) in
            switch result {
            case .success(let model):
                guard let self = self else { return }
                let modelResponse = model.response.song
                var songDescription = ""
                
                if let descriptionResult = modelResponse.description {
                    songDescription = UtilManager.shared.parseHTML(from: descriptionResult.html)
                }
                
                self.songViewModel = SongViewModel(stats: modelResponse.stats,
                                                   album: modelResponse.album,
                                                   releaseDate: modelResponse.releaseDate ?? "-",
                                                   description: songDescription)
                
                DispatchQueue.main.async {
                    if let pageViews = modelResponse.stats.pageviews {
                        self.viewsLabel.text = self.getViews(from: pageViews)
                    } else {
                        self.viewsLabel.text = "0"
                    }
                }
                
                self.fetchLyrics(from: modelResponse.path)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchLyrics(from url: String) {
        ApiService.shared.request(endpoint: LyricEndpoint.getLyrics(fromUrl: url)) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else { return }
                
                let songLyrics = UtilManager.shared.extrachLyrics(from: data)
                
                self.lyrics = songLyrics
                self.descriptionView.descriptionLabel.text = songLyrics
                self.bookmarkLyricViewModel.lyrics = self.lyrics
                
                let bookmarkButton = UIBarButtonItem(image: UIImage(systemName:  self.isBookmarked ? "bookmark.fill" : "bookmark"), style: .plain, target: self, action: #selector(self.didTapBookmarkButton))
                self.navigationItem.rightBarButtonItem = bookmarkButton
                
            case .failure(let error)
            :
                print(error.localizedDescription)
            }
        }
    }
    
    private func getViews(from: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: from as NSNumber) ?? "0"
    }
    
    @objc func didTapAbout() {
        guard let songData = self.songViewModel,
              !lyrics.isEmpty else {
            return
        }
        
        let vc = AboutViewController(songData: songData)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
}
