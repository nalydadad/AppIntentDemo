//
//  ContentView.swift
//  AppIntentDemo2
//
//  Created by Dada on 8/3/24.
//

import SwiftUI
import CoreData
import AppIntents

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(NavigationManager.self) private var navigation
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ItemModel.pinned, ascending: false),
            NSSortDescriptor(keyPath: \ItemModel.title, ascending: true)],
        predicate: NSPredicate(format: "pinned == %@", true as NSNumber),
        animation: .default)
    private var pinnedItems: FetchedResults<ItemModel>
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ItemModel.pinned, ascending: false),
            NSSortDescriptor(keyPath: \ItemModel.timestamp, ascending: false)],
        predicate: NSPredicate(format: "pinned == %@", false as NSNumber),
        animation: .default)
    private var unpinnedItems: FetchedResults<ItemModel>
    
    @State private var name: String = ""
    @State private var showingAlert = false
    @State private var showHint = true
    @State private var selectedDate: Date = Date()
    @State private var searchText: String = ""
    
    var body: some View {
        @Bindable var navigation = navigation
        NavigationStack(path: $navigation.path) {
            List {
                Section() {
                    if showHint {
                        SiriTipView(intent: OpenItemIntent(), isVisible: $showHint)
                            .listRowInsets(.init(top: 0, leading: 5, bottom: 0, trailing: 5))
                    }
                }
                
                Section {
                    ForEach(pinnedItems) { item in
                        NavigationLink(value: item) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.title ?? "")
                                        .font(.title3)
                                    Text(item.timestamp?.formatted() ?? "")
                                        .font(.caption)
                                }
                                Spacer()
                                if item.pinned {
                                    Image(systemName: "pin")
                                }
                            }
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            HStack {
                                Button(action: {
                                    deleteItems(item: item)
                                }) {
                                    Image(systemName: "trash")
                                }
                                
                                Button(action: {
                                    item.pinned.toggle()
                                    save()
                                }) {
                                    item.pinned ? Image(systemName: "pin.slash") : Image(systemName: "pin.fill")
                                    
                                }
                                
                            }
                        }
                    }
                }
                
                Section {
                    ForEach(unpinnedItems) { item in
                        NavigationLink(value: item) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.title ?? "")
                                        .font(.title3)
                                    Text(item.timestamp?.formatted() ?? "")
                                        .font(.caption)
                                }
                                Spacer()
                                if item.pinned {
                                    Image(systemName: "pin")
                                }
                            }
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            HStack {
                                Button(action: {
                                    deleteItems(item: item)
                                }) {
                                    Image(systemName: "trash")
                                }
                                
                                Button(action: {
                                    item.pinned.toggle()
                                    save()
                                }) {
                                    item.pinned ? Image(systemName: "pin.slash") : Image(systemName: "pin.fill")
                                }
                                
                            }
                        }
                    }
                }
                
                //                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showingAlert = true
                    }, label: {
                        Label("Add Item", systemImage: "plus")
                    })
                }
            }
            .navigationDestination(for: ItemModel.self, destination: { item in
                DetailView(item: item)
            })
            .navigationTitle("Quick notes")
        }
        .searchable(text: $navigation.searchText)
        .onChange(of: navigation.searchText, { _, new in
            let containNamePredicate = NSPredicate(format: "title CONTAINS[c] %@", new as NSString)
            let pinndedPrecicate = NSPredicate(format: "pinned == %@", true as NSNumber)
            let unpinnedPrecicate = NSPredicate(format: "pinned == %@", false as NSNumber)
            pinnedItems.nsPredicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: new.isEmpty ? [pinndedPrecicate] : [containNamePredicate, pinndedPrecicate])
            unpinnedItems.nsPredicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: new.isEmpty ? [unpinnedPrecicate] : [containNamePredicate, unpinnedPrecicate])
        })
        .alert("Add Todos", isPresented: $showingAlert) {
            TextField("Item Name", text: $name)
            Button("Cancel") {
                showingAlert = false
            }
            Button("OK") {
                addItem(name: name)
            }
            .disabled(name.isEmpty)
        }
    }
    
    private func addItem(name: String) {
        withAnimation {
            do {
                try viewContext.addItem(name: name)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(item: ItemModel) {
        withAnimation {
            viewContext.delete(item)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteOffset(offsets: IndexSet) {
        withAnimation {
            offsets.map { pinnedItems[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            
        }
    }
}
