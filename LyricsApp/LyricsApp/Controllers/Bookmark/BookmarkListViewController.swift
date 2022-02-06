//
//  BookmarkViewController.swift
//  LyricsApp
//
//  Created by Obed Garcia on 4/2/22.
//

import UIKit
import CoreData

class BookmarkListViewController: UIViewController {
    private var tableView = UITableView()
    private var dataSource: BookmarkLyricDataSource!
    private var searchedText: String = ""
    lazy var fetchedResultsController: NSFetchedResultsController<LyricEntity> = getFetchResultController()
    let searchController: UISearchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchBar.placeholder = "Search artist"
        view.searchBar.searchBarStyle = .minimal
        view.definesPresentationContext = true
        view.obscuresBackgroundDuringPresentation = false
        return view
    }()
    var bookmarkLyricViewModel = BookedmarkLyricViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureTableView()
        configureDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        MARK: - Delete all records - Debugging
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LyricEntity")
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        batchDeleteRequest.resultType = .resultTypeObjectIDs
//        do {
//            let result = try LyricAppDataService.shared.context.execute(batchDeleteRequest) as! NSBatchDeleteResult
//            let changes: [AnyHashable: Any] = [
//                NSDeletedObjectsKey: result.result as! [NSManagedObjectID]
//            ]
//            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [LyricAppDataService.shared.context])
//        } catch {
//            print("Error trying to delete")
//        }
        
        fetchBookmarks()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
     
        view.backgroundColor = .systemBackground
       
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.register(BookmarkLyricTableViewCell.self, forCellReuseIdentifier: BookmarkLyricTableViewCell.identifier)
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
    }
    
    private func getFetchResultController() -> NSFetchedResultsController<LyricEntity> {
        let fetchRequest: NSFetchRequest<LyricEntity> = LyricEntity.fetchRequest()
        let artistNameSort = NSSortDescriptor(key: #keyPath(LyricEntity.artist), ascending: true)
        fetchRequest.sortDescriptors = [artistNameSort]
        fetchRequest.fetchBatchSize = 20
        
        if !searchedText.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "artist CONTAINS[c] %@", searchedText)
        }
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: LyricAppDataService.shared.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }
    
    private func configureDataSource() {
        dataSource = BookmarkLyricDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, objectID) -> UITableViewCell? in
            guard let object = try? LyricAppDataService.shared.context.existingObject(with: objectID) else { return UITableViewCell() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkLyricTableViewCell.identifier, for: indexPath)
                    as? BookmarkLyricTableViewCell else { return UITableViewCell() }
            
            
            let id = object.value(forKey: "id") as? String ?? ""
            let songTitle = object.value(forKey: "songTitle") as? String ?? ""
            let artist = object.value(forKey: "artist") as? String ?? ""
            let lyrics = object.value(forKey: "lyrics") as? String ?? ""
            
            let vm = BookmarkedLyricCellViewModel(id: id,
                                                  songTitle: songTitle,
                                                  artist: artist,
                                                  lyrics: lyrics)
            
            cell.configure(with: vm)
            return cell
        })
    }
    
    private func fetchBookmarks() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    
}

// MARK: - TableView Delegate
extension BookmarkListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let objectID = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let bookmark = try? LyricAppDataService.shared.context.existingObject(with: objectID) else { return }
        
        let vc = BookmarkedLyricViewController()
        vc.selectedBookmark = bookmark
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (contextualAction, view, completionHandler) in
            guard let self = self else { return }
            guard let objectID = self.dataSource.itemIdentifier(for: indexPath) else { return }
            guard let bookmark = try? LyricAppDataService.shared.context.existingObject(with: objectID) else { return }
            
            self.bookmarkLyricViewModel.delete(bookmark: bookmark) { (result) in
                switch result {
                case .success(let wasDeleted):
                    print("Deleted \(wasDeleted)")
                    completionHandler(true)

                case .failure(let error):
                    print("error \(error)")
                }
            }
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = true
        return swipeConfiguration
    }
}

// MARK: - NSFetchedResultsController Delegate
extension BookmarkListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        guard let dataSource = tableView.dataSource as? UITableViewDiffableDataSource<Section, NSManagedObjectID> else {
            return
        }
        
        var snapshot = snapshot as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>
        let currentSnapshot = dataSource.snapshot() as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>
        
        let reloadIdentifiers: [NSManagedObjectID] = snapshot.itemIdentifiers.compactMap { itemIdentifier in
            guard let currentIndex = currentSnapshot.indexOfItem(itemIdentifier), let index = snapshot.indexOfItem(itemIdentifier), index == currentIndex else {
                return nil
            }
            guard let existingObject = try? controller.managedObjectContext.existingObject(with: itemIdentifier), existingObject.isUpdated else { return nil }
            return itemIdentifier
        }
        snapshot.reloadItems(reloadIdentifiers)
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>, animatingDifferences: true)
    }
}

// MARK: - SearchController Delegate
extension BookmarkListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
              !searchText.isEmpty else {
            return
        }
        searchedText = searchText
        fetchedResultsController = getFetchResultController()
        fetchBookmarks()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        fetchNotes()
    }
}

// MARK: - DataSource
class BookmarkLyricDataSource: UITableViewDiffableDataSource<Section, NSManagedObjectID> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

enum Section {
    case main
}
