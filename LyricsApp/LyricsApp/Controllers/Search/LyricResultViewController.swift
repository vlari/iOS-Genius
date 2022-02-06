//
//  LyricResultViewController.swift
//  LyricsApp
//
//  Created by Obed Garcia on 23/11/21.
//

import UIKit
import Lottie

class LyricResultViewController: UIViewController {
    private var textField: LTextField = {
        let textField = LTextField(placeHolder: "Search lyrics")
        return textField
    }()
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: LyricResultViewController.buildCollectionViewLayout()
    )
    private var cellViewModels: [SearchLyricCellViewModel] = []
    private var searchText: String = ""
    var baseFilterText: String!
    private var loadingView: LoadingView =  {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        return loadingView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.addSubview(textField)
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UtilManager.shared.getNavigationAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 30
            
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            textField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Methods
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(SearchLyricCollectionViewCell.self, forCellWithReuseIdentifier: SearchLyricCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setLoadingView() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private static func buildCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectonPadding: CGFloat = 8
        let itemPadding: CGFloat = 8
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: itemPadding, bottom: itemPadding, trailing: itemPadding)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
                
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: sectonPadding, leading: sectonPadding, bottom: sectonPadding, trailing: sectonPadding)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        title = "Search"
        textField.delegate = self
        searchText = baseFilterText
        textField.text = baseFilterText
    }
    
    private func fetchData() {
        ApiService.shared.request(endpoint: LyricEndpoint.getSearchResult(searchText: searchText)) { [weak self] (result: Result<SearcResponse, Error>) in
            switch result {
            case .success(let model):
                guard let self = self else { return }
                guard model.response.hits.count > 0 else { return }
                
                let modelResponse = model.response.hits
                
                self.cellViewModels.append(contentsOf: modelResponse.compactMap({
                    return SearchLyricCellViewModel(id: $0.result.id, title: $0.result.title, songThumbnail: $0.result.songImage, artistName: $0.result.artistNames, apiPath: $0.result.apiPath)
                }))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.loadingView.removeFromSuperview()
                    self.configureCollectionView()
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - CollectonView delegate
extension LyricResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchLyricCollectionViewCell.identifier, for: indexPath)
                as? SearchLyricCollectionViewCell else { return UICollectionViewCell() }
        
        let cellData = cellViewModels[indexPath.item]
        cell.configure(with: cellData)
        
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let lyricData = cellViewModels[indexPath.item]
        
        let vc = LyricViewController(lyricData: lyricData)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITextfield delegate
extension LyricResultViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
              !text.isEmpty else {
            return false
        }

        view.addSubview(loadingView)
        loadingView.animationView.play()
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        textField.resignFirstResponder()
        collectionView.removeFromSuperview()
        cellViewModels = []
        searchText = text
        fetchData()
        
        return true
    }
}
