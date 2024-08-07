//
//  PinItemIntent.swift
//  AppIntentDemo2
//
//  Created by Dada on 8/6/24.
//

import AppIntents

struct ToggleItemIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Pinned Status"
    
    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$toggle) \(\.$item)")
    }
    
    @Parameter(title: "toggle")
    var toggle: PinnedStatus
    
    @Parameter(title: "Item")
    var item: PinItemEntity
    
    @Dependency
    var persistentController: PersistenceController
    
    @MainActor
    func perform() async throws -> some IntentResult {
        guard let item = try persistentController.container.viewContext.findItemsBy(identifiers: [item.id]).first else {
            return .result()
        }
        item.pinned = toggle.isPinned
        try persistentController.container.viewContext.save()
        return .result()
    }
}

extension ToggleItemIntent {
    enum PinnedStatus: String, AppEnum {
        static var typeDisplayRepresentation: TypeDisplayRepresentation = "Pinned Toggle"
        
        static var caseDisplayRepresentations: [PinnedStatus : DisplayRepresentation] {
            [.pinned: "Pinned", .unpinned: "Not Pinned"]
        }
        
        case pinned = "Pinned"
        case unpinned = "Not Pinned"
        
        var isPinned: Bool {
            return self == .pinned
        }
    }
}

struct PinItemEntity: AppEntity {
    static var defaultQuery: PinItemQuery = PinItemQuery()
    
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

struct PinItemQuery: EntityQuery {
    @Dependency
    var persistentController: PersistenceController
    
    func entities(for identifiers: [String]) async throws -> [PinItemEntity] {
        let result = try persistentController.container.viewContext.findItemsBy(identifiers: identifiers)
        return result.compactMap {
            PinItemEntity(id: $0.id?.uuidString ?? "", name: $0.title ?? "", date: $0.timestamp ?? Date(), pinned: $0.pinned)
        }
    }
    
    func suggestedEntities() async throws -> [PinItemEntity] {
        let result = try persistentController.container.viewContext.findItems()
        return result.compactMap {
            PinItemEntity(id: $0.id?.uuidString ?? "", name: $0.title ?? "", date: $0.timestamp ?? Date(), pinned: $0.pinned)
        }
    }
}

extension PinItemQuery: EntityStringQuery {
    func entities(matching string: String) async throws -> [PinItemEntity] {
        let result = try persistentController.container.viewContext.findItemsBy(name: string)
        return result.compactMap {
            PinItemEntity(id: $0.id?.uuidString ?? "",
                       name: $0.title ?? "",
                       date: $0.timestamp ?? Date(),
                       pinned: $0.pinned)
        }
    }
}
