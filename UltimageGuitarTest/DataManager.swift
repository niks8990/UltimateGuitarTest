//
//  DataManager.swift
//  UltimageGuitarTest
//
//  Created by Igor Shavlovsky on 5/20/17.
//  Copyright © 2017 Nikita Smolyanchenko. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    typealias FetchedResult = (hasResult: Bool, data: Any?)
    
    static let shared = DataManager()
    
    fileprivate override init() {
        super.init()
    }
    
    // MARK: - Core Data stack
    //Managed Model
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "UltimageGuitarTest", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        return model
    }()
    
    //Store coordinator
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("UltimageGuitarTestDB.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "com.test", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    //Managed Context
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // Returns the URL to the application's Documents directory.
    var applicationDocumentsDirectory: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex-1] as URL
    }
    
    // MARK: - Core Data Saving support
    func saveContext (_ context: NSManagedObjectContext = DataManager.shared.managedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
        if context !== self.managedObjectContext {
            OperationQueue.main.addOperation({
                self.saveContext()
            })
            //            saveContext()
        }
    }
    
    func tempContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = self.managedObjectContext
        return managedObjectContext
    }
    
    func getAlbumsList(context: NSManagedObjectContext = DataManager.shared.managedObjectContext) -> FetchedResult {
        var result: FetchedResult = (false, nil)
        var albums: [Album] = []
        
        do {
            let fetchRequest: NSFetchRequest<CDAlbum> = CDAlbum.fetchRequest()
            let fetchedResults = try context.fetch(fetchRequest)
            for album in fetchedResults {
                albums.append(Album(cdAlbum: album))
            }
        } catch{
        }
        
        if albums.count > 0 {
            result = (true, albums)
            return result
        } else {
            return result
        }
    }
    
    func insertAlbum(_ album: Album, context: NSManagedObjectContext = DataManager.shared.managedObjectContext) {
        var newCDAlbum: CDAlbum
        
        let albumEntity = NSEntityDescription.entity(forEntityName: String(describing: CDAlbum.self), in: context)
        newCDAlbum = CDAlbum(entity: albumEntity!, insertInto: context)
        
        newCDAlbum.populate(album: album)
        saveContext(context)
    }
    
    func deleteAlbumById(_ id: String?, context: NSManagedObjectContext = DataManager.shared.managedObjectContext) {
        guard let albumId = id else {
            return
        }
        let fetchRequest: NSFetchRequest<CDAlbum> = CDAlbum.fetchRequest()
        let fetchPredicate = NSPredicate(format: "id == %@", albumId)
        fetchRequest.predicate = fetchPredicate
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            if fetchedResults.count > 0 {
                context.delete(fetchedResults.first!)
                saveContext()
            }
        } catch {
        }

    }
    
    func containsAlbumWithId(_ id: String?, context: NSManagedObjectContext = DataManager.shared.managedObjectContext) -> Bool {
        guard let albumId = id else {
            return false
        }
        let fetchRequest: NSFetchRequest<CDAlbum> = CDAlbum.fetchRequest()
        let fetchPredicate = NSPredicate(format: "id == %@", albumId)
        fetchRequest.predicate = fetchPredicate
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            if fetchedResults.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
        }
        return false
    }
    
}
