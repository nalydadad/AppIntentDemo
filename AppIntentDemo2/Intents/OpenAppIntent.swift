//
//  OpenAppIntent.swift
//  AppIntentDemo2
//
//  Created by Dada on 8/3/24.
//

import Foundation
import AppIntents

struct OpenAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Open App"
    static var description: IntentDescription? = IntentDescription("Open App", categoryName: "Open")
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
