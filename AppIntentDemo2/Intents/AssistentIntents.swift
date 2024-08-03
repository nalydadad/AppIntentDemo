//
//  AssistentIntents.swift
//  AppIntentDemo2
//
//  Created by Dada on 8/3/24.
//

import Foundation
import AppIntents

@AssistantIntent(schema: .mail.sendDraft)
struct SendDraftIntent {
    var target: MailDraftEntity
    var sendLaterDate: Date?
    
    func perform() async throws -> some IntentResult {
        .result()
    }
}

@AssistantEntity(schema: .mail.draft)
struct MailDraftEntity {
    
    static var defaultQuery = DraftQuery()
    
    struct DraftQuery: EntityStringQuery {
        init() {}
        func entities(for identifiers: [MailDraftEntity.ID]) async throws -> [MailDraftEntity] { [] }
        func entities(matching string: String) async throws -> [MailDraftEntity] { [] }
    }
    
    var displayRepresentation: DisplayRepresentation { "Unimplemented" }
    
    let id = UUID()
    
    var to: [IntentPerson]
    var cc: [IntentPerson]
    var bcc: [IntentPerson]
    var subject: String?
    var body: String?
    var attachments: [IntentFile]
    var account: MailAccountEntity
}

@AssistantEntity(schema: .mail.account)
struct MailAccountEntity {
    
    static var defaultQuery = AccountQuery()
    
    struct AccountQuery: EntityStringQuery {
        init() {}
        func entities(for identifiers: [MailAccountEntity.ID]) async throws -> [MailAccountEntity] { [] }
        func entities(matching string: String) async throws -> [MailAccountEntity] { [] }
    }
    
    var displayRepresentation: DisplayRepresentation { "Unimplemented" }
    
    let id = UUID()
    
    var name: String
    var emailAddress: String
}
