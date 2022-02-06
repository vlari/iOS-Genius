//
//  BookmarkLyricViewModel.swift
//  LyricsApp
//
//  Created by Obed Garcia on 6/2/22.
//

import Foundation
import CoreData

class BookedmarkLyricViewModel {
    var id: String = ""
    var songTitle: String = ""
    var artist: String = ""
    var lyrics: String = ""
    
    func isBookmarked(for id: String) -> Bool {
        let objectEnitty = getExisting(by: id)
        
        guard let entity = objectEnitty,
              let id = entity.id,
              !id.isEmpty else {
            return false
        }
        
        return true
    }
    
    func getExisting(by id: String) -> LyricEntity? {
        let fetchRequest: NSFetchRequest<LyricEntity>
        fetchRequest = LyricEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "id = %@", id
        )
        
        do {
            let objects = try LyricAppDataService.shared.context.fetch(fetchRequest)
            return objects.first
        } catch {
            return nil
        }
    }
    
    func save(completion: @escaping (Result<Bool, Error>) -> ()) {
        LyricAppDataService.shared.performBackgroundTask { [weak self] (context) in
            guard let self = self else { return }
            
            let lyricData = LyricEntity(context: context)
            lyricData.id = self.id
            lyricData.songTitle = self.songTitle
            lyricData.artist = self.artist
            lyricData.lyrics = self.lyrics
            
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func delete(bookmark item: NSManagedObject, completion: @escaping (Result<Bool, Error>) -> ()) {
        do {
            LyricAppDataService.shared.context.delete(item)
            try LyricAppDataService.shared.context.save()
            DispatchQueue.main.async {
                completion(.success(true))
            }
        } catch let error as NSError {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
