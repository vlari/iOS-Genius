//
//  LyricDataService.swift
//  LyricsApp
//
//  Created by Obed Garcia on 5/2/22.
//

import Foundation
import CoreData

class LyricAppDataService {
    static let shared = LyricAppDataService()
    var persistentContainer: NSPersistentContainer!
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didSaveBackgroundContext(notification:)), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    // Merge changes when using backgroundcontext
    @objc func didSaveBackgroundContext(notification: Notification) {
        guard let notificationContext = notification.object as? NSManagedObjectContext else { return }
        
        guard notificationContext !== context else { return }
        
        context.perform {
            self.context.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    // Execunting background operation
    func performBackgroundTask(block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
    // Initialize Core Data Stack
    func initialize() {
        persistentContainer = NSPersistentContainer(name: "LyricsAppData")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                print("Unresolved error \(error)")
                fatalError()
            }
        }
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
    }
    
    func saveContext() {
        do {
            if persistentContainer.viewContext.hasChanges {
                try persistentContainer.viewContext.save()
            }
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            //print(error.localizedDescription)
        }
    }
}
