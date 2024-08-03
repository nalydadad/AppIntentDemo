//
//  AppIntentDemo2App.swift
//  AppIntentDemo2
//
//  Created by Dada on 8/3/24.
//

import SwiftUI
import AppIntents

@main
struct AppIntentDemo2App: App {
    let persistenceController = PersistenceController.shared
    
    init () {
        Shortcuts.updateAppShortcutParameters()
        AppDependencyManager.shared.add(dependency: PersistenceController.shared)
        AppDependencyManager.shared.add(dependency: NavigationManager())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
