//
//  OpenItemIntent.swift
//  AppIntentDemo2
//
//  Created by Dada on 8/3/24.
//

import AppIntents
import CoreData
import SwiftUI

struct OpenItemIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Item"
    static var description: IntentDescription? = IntentDescription("Open an item in the app.", categoryName: "Open")

    static var parameterSummary: some ParameterSummary { Summary("Open \(\.$item)") }
    
    init() {}
    
    init(item: ItemEntity) {
        self.item = item
    }
    
    @Parameter(title: "Item")
    var item: ItemEntity
    
    @Dependency
    var navigatoinManager: NavigationManager
    
    @Dependency
    var persistentController: PersistenceController

    @MainActor
    func perform() async throws -> some IntentResult  {
        return .result()
    }
}

struct ItemEntity: AppEntity {
    static var defaultQuery: ItemQuery = ItemQuery()
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        .init(name: "Quick Note Item")
    }
    
    let id: String
    let name: String
    let date: Date
    let pinned: Bool
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: LocalizedStringResource("%@", defaultValue: String.LocalizationValue(name)),
            image: .init(systemName: pinned ? "pin" : "pin.slash")
        )
    }
}

struct ItemQuery: EntityQuery {
    @Dependency
    var persistentController: PersistenceController
    
    func entities(for identifiers: [String]) async throws -> [ItemEntity] {
        let context = persistentController.container.viewContext
        let request: NSFetchRequest<ItemModel> = ItemModel.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", identifiers)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ItemModel.pinned, ascending: false),
            NSSortDescriptor(keyPath: \ItemModel.title, ascending: true),
        ]
        request.fetchLimit = 10
        let result = try context.fetch(request)
        return result.compactMap {
            ItemEntity(id: $0.id?.uuidString ?? "", name: $0.title ?? "", date: $0.timestamp ?? Date(), pinned: $0.pinned)
        }
    }
    
    func suggestedEntities() async throws -> [ItemEntity] {
        let context = persistentController.container.viewContext
        let request: NSFetchRequest<ItemModel> = ItemModel.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ItemModel.pinned, ascending: false),
            NSSortDescriptor(keyPath: \ItemModel.title, ascending: true),
        ]
        request.fetchLimit = 10
        let result = try context.fetch(request)
        return result.compactMap {
            ItemEntity(id: $0.id?.uuidString ?? "", name: $0.title ?? "", date: $0.timestamp ?? Date(), pinned: $0.pinned)
        }
    }
}

extension ItemQuery: EntityStringQuery {
    func entities(matching string: String) async throws -> [ItemEntity] {
        let context = persistentController.container.viewContext
        let request: NSFetchRequest<ItemModel> = ItemModel.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[c] %@", string)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ItemModel.pinned, ascending: false),
            NSSortDescriptor(keyPath: \ItemModel.title, ascending: true),
        ]
        request.fetchLimit = 10
        let result = try context.fetch(request)
        return result.compactMap {
            ItemEntity(id: $0.id?.uuidString ?? "",
                       name: $0.title ?? "",
                       date: $0.timestamp ?? Date(),
                       pinned: $0.pinned)
        }
    }
}

struct ItemSnippedView: View {
    let item: ItemModel
    
    var body: some View {
        VStack {
            Image(systemName: item.pinned ? "pin" : "pin.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 500)
            Text(item.title ?? "")
            Text(item.timestamp ?? Date(), style: .date)
        }
    }
}
