//
//  BookmarkedLyricViewController.swift
//  LyricsApp
//
//  Created by Obed Garcia on 5/2/22.
//

import UIKit
import CoreData

class BookmarkedLyricViewController: UIViewController {
    let bookmarkLyricViewModel = BookedmarkLyricViewModel()
    var selectedBookmark: NSManagedObject?
    var songDetailView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let songTitleLabel: UILabel = {
       let label = UILabel()
        label.minimumScaleFactor = 0.10
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: CustomFont.regular.apply, size: 24)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    private let artistLabel: UILabel = {
       let label = UILabel()
        label.minimumScaleFactor = 0.10
        label.textColor = UIColor.theme.accent
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    private var descriptionView: DescriptionView = DescriptionView(title: "Lyrics")
    let detailStackView = UIStackView()
    private var isBookmarked: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        addSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = ""
        let appearance = UtilManager.shared.getNavigationAppearance()
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            songDetailView.topAnchor.constraint(equalTo: view.topAnchor),
            songDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            songDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            songDetailView.heightAnchor.constraint(greaterThanOrEqualTo: detailStackView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailStackView.topAnchor.constraint(equalTo: songDetailView.topAnchor, constant: 6),
            detailStackView.leadingAnchor.constraint(equalTo: songDetailView.leadingAnchor, constant: 6),
            detailStackView.trailingAnchor.constraint(equalTo: songDetailView.trailingAnchor, constant: -6),
            detailStackView.bottomAnchor.constraint(equalTo: songDetailView.bottomAnchor, constant: -6)
        ])
        
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: songDetailView.bottomAnchor, constant: 10),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configure() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        edgesForExtendedLayout = []
    }
    
    private func addSubViews() {
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.axis = .vertical
        detailStackView.alignment = .leading
        detailStackView.spacing = 10
        
        self.setViewModel()
        
        songTitleLabel.text = bookmarkLyricViewModel.songTitle
        artistLabel.text = bookmarkLyricViewModel.artist
        descriptionView.descriptionLabel.text = bookmarkLyricViewModel.lyrics
        
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(self.didTapDeleteButton))
        self.navigationItem.rightBarButtonItem = deleteButton
        
        detailStackView.addArrangedSubview(songTitleLabel)
        detailStackView.addArrangedSubview(artistLabel)
        
        songDetailView.addSubview(detailStackView)
        
        view.addSubview(songDetailView)
        
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionView)
    }
    
    private func setViewModel() {
        if let bookmark = selectedBookmark {
            bookmarkLyricViewModel.id = bookmark.value(forKey: "id") as? String ?? ""
            bookmarkLyricViewModel.songTitle = bookmark.value(forKey: "songTitle") as? String ?? ""
            bookmarkLyricViewModel.artist = bookmark.value(forKey: "artist") as? String ?? ""
            bookmarkLyricViewModel.lyrics = bookmark.value(forKey: "lyrics") as? String ?? ""
        }
    }
    
    @objc func didTapDeleteButton() {
        let bookmark = bookmarkLyricViewModel.getExisting(by: bookmarkLyricViewModel.id)!
        
        bookmarkLyricViewModel.delete(bookmark: bookmark) { [weak self] (result) in
            switch result {
            case .success(let wasDeleted):
                print("Deleted \(wasDeleted)")
                self?.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
}
