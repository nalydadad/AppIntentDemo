//
//  Persistence.swift
//  AppIntentDemo2
//
//  Created by Dada on 8/3/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = ItemModel(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "AppIntentDemo2")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension NSManagedObjectContext {
    func findItems(fetchLimit: Int = 10) throws -> [ItemModel]  {
        let request: NSFetchRequest<ItemModel> = ItemModel.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ItemModel.pinned, ascending: false),
            NSSortDescriptor(keyPath: \ItemModel.title, ascending: true),
        ]
        request.fetchLimit = 10
        let result = try fetch(request)
        return result
    }
    
    func findItemsBy(name: String, fetchLimit: Int = 10) throws -> [ItemModel] {
        let request: NSFetchRequest<ItemModel> = ItemModel.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[c] %@", name)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ItemModel.pinned, ascending: false),
            NSSortDescriptor(keyPath: \ItemModel.title, ascending: true),
        ]
        request.fetchLimit = 10
        let result = try fetch(request)
        return result
    }
    
    func findItemsBy(identifiers: [String], fetchLimit: Int = 10) throws -> [ItemModel] {
        let request: NSFetchRequest<ItemModel> = ItemModel.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", identifiers)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ItemModel.pinned, ascending: false),
            NSSortDescriptor(keyPath: \ItemModel.title, ascending: true),
        ]
        request.fetchLimit = 10
        let result = try fetch(request)
        return result
    }
    
    func addItem(name: String, pinned: Bool = false) throws {
        let newItem = ItemModel(context: self)
        newItem.id = UUID()
        newItem.timestamp = Date()
        newItem.title = name
        newItem.pinned = pinned
        try save()
    }
    
}
