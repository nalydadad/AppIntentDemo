//
//  OnboardingIntent.swift
//  AppIntentDemo2
//
//  Created by Dada on 8/4/24.
//

import AppIntents
import SwiftUI

struct OnboardingIntent: AppIntent {
    static var title: LocalizedStringResource = "Onboarding"
    static var description: IntentDescription? = IntentDescription("Tell you how to use", categoryName: "Onboarding")
    static var openAppWhenRun: Bool = false
    
    @MainActor
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        return .result(content: {
            OnboardingSnippetView()
        })
    }
}

struct MirrorShortcut: Identifiable, Hashable {
    static func == (lhs: MirrorShortcut, rhs: MirrorShortcut) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: UUID = .init()
    private let mirror: Mirror
    init?(shortcut: AppShortcut) {
        mirror = Mirror(reflecting: shortcut)
        guard let title, let phrases else {
            return nil
        }
    }
    
    var title: String? {
        guard let localized = mirror.children.first(where: {
            $0.label == "shortTitle"
        })?.value as? LocalizedStringResource else {
            return nil
        }
        return String(localized: localized)
    }
    
    var phrases: [String]? {
        let phrases = mirror.children.first(where: {
            $0.label == "basePhraseTemplates"
        })?.value as? [String]
        
        return phrases?.map { phrase in
            phrase.replacingOccurrences(of: "${applicationName}", with: appName)
        }
    }
    
    var appName: String {
        Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }
}

struct OnboardingSnippetView: View {
    var shortcuts: [MirrorShortcut] {
        Shortcuts.appShortcuts.compactMap { MirrorShortcut(shortcut: $0) }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("You can say: ")
                .font(.headline)
                .padding()
            ForEach(shortcuts) { shortcut in
                VStack(alignment: .leading) {
                    Text(shortcut.title ?? "")
                        .font(.headline)
                    
                    ForEach(shortcut.phrases ?? [], id: \.self) { phrase in
                        HStack {
                            Text("\"\(phrase)\"")
                            Spacer()
                        }
                    }
                }
                .padding()
            }
        }
    }
}
