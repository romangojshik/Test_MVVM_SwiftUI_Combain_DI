//
//  DependencyContainer.swift
//  StateObject
//
//  Created by Roman Gojshik on 1.12.25.
//

import Foundation
import Combine

final class DependencyContainer: ObservableObject {
    let entryStore: EntryStore
    
    init() {
        self.entryStore = EntryStore()
    }
}

