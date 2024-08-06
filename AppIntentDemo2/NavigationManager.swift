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
    
    func open(item: ItemModel) {
        path.append(item)
    }
}
