//
//  CreateItemIntent.swift
//  AppIntentDemo2
//
//  Created by Dada on 8/6/24.
//

import AppIntents

struct CreateItemIntent: AppIntent {
    static var title: LocalizedStringResource = "Create Item"
    
    static var parameterSummary: some ParameterSummary {
        Summary("Create \(\.$pinned) item with \(\.$name).")
    }
    
    @Parameter(title: "pinnded")
    var pinned: PinnedStatus
    
    @Parameter(title: "name")
    var name: String
    
    @Dependency
    var persistentController: PersistenceController
    
    @MainActor
    func perform() async throws -> some IntentResult {
        try persistentController.container.viewContext.addItem(name: name, pinned: pinned.isPinned)
        return .result()
    }
}

extension CreateItemIntent {
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



