//
//  ContentViewModel.swift
//  StateObject
//
//  Created by Roman Gojshik on 1.12.25.
//

import Foundation
import Combine

final class ContentViewModel: ObservableObject {
    @Published var refreshTimestamp: String = ""
    
    init() {
        refresh()
    }
    
    func refresh() {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        refreshTimestamp = "Last refresh: \(formatter.string(from: Date()))"
    }
}

