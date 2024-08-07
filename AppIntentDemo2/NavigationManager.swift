//
//  NavigationManager.swift
//  AppIntentDemo2
//
//  Created by Dada on 8/4/24.
//

import Observation
import SwiftUI


@Observable
final class NavigationManager {
    static let shared = NavigationManager()
    var path = NavigationPath()
    var searchText = ""
    
    func open(item: ItemModel) {
        path.append(item)
    }
    
    func search(_ searchText: String) {
        path = NavigationPath()
        self.searchText = searchText
    }
}
