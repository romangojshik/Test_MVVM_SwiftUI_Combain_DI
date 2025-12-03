//
//  StateObjectApp.swift
//  StateObject
//
//  Created by Roman Gojshik on 1.12.25.
//

import SwiftUI

@main
struct StateObjectApp: App {
    @StateObject private var dependencyContainer = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dependencyContainer)
        }
    }
}
