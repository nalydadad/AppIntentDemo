//
//  DetailView.swift
//  AppIntentDemo2
//
//  Created by Dada on 8/3/24.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    var item: ItemModel
    @State private var selectedDate: Date
    @State private var text: String
    @State private var isPinned: Bool
    
    init(item: ItemModel) {
        self.item = item
        self.selectedDate = item.timestamp ?? Date()
        self.text = item.title ?? ""
        self.isPinned = item.pinned
    }
    
    var body: some View {
        VStack(spacing: 10) {
            TextField("Title", text: $text)
                .padding(10)
                .background(Color.white)
                .cornerRadius(5)
                .onChange(of: text) { newText in
                    item.title = newText
                }
                
            DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                .padding(10)
                .background(Color.white)
                .cornerRadius(5)
                .onChange(of: selectedDate) { newDate in
                    item.timestamp = newDate
                }
            
            Toggle(isOn: $isPinned) {
                Text("Pin")
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(5)
            .onChange(of: isPinned) { isPinned in
                item.pinned = isPinned
            }
            Spacer()
        }
        .padding(16)
        .background(Color.gray.opacity(0.1))
        .toolbar {
            ToolbarItem {
                Button("Save") {
                    do {
                        try viewContext.save()
                        dismiss()
                    } catch {
                        
                    }
                }
            }
        }
    }
}
