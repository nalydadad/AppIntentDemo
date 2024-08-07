//
//  ShortcutProvider.swift
//  AppIntentDemo2
//
//  Created by Dada on 8/3/24.
//

import AppIntents

struct Shortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        return [
            AppShortcut(
                intent: OnboardingIntent(),
                phrases: [
                    "Show me the phrases of \(.applicationName) ",
                    "How to use \(.applicationName) ",
                ],
                shortTitle: "Onboarding",
                systemImageName: "info.circle"),
            AppShortcut(
                intent: OpenAppIntent(),
                phrases: [
                    "Open \(.applicationName)"
                ],
                shortTitle: "Open App",
                systemImageName: "star"),
            AppShortcut(
                intent: OpenItemIntent(),
                phrases: [
                    "Open \(\.$item) in \(.applicationName)"
                ],
                shortTitle: "Open Item",
                systemImageName: "list.bullet"
            ),
            AppShortcut(
                intent: ToggleItemIntent(),
                phrases: [
                    "\(\.$toggle) in \(.applicationName)"
                ],
                shortTitle: "Toggle Item",
                systemImageName: "list.bullet"
            ),
            AppShortcut(
                intent: CreateItemIntent(),
                phrases: [
                    "Create \(\.$pinned) in \(.applicationName)"
                ],
                shortTitle: "Create Item",
                systemImageName: "plus.circle"
            ),
            
        ]
    }
}
