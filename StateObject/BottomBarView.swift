//
//  BottomBarView.swift
//  StateObject
//
//  Created by Roman Gojshik on 1.12.25.
//

import Combine
import SwiftUI

struct BottomBarView: View {
    @StateObject var viewModel: BottomBarViewModel
    
    var body: some View {
        Text(viewModel.text)
    }
}

final class BottomBarViewModel: ObservableObject {
    @Published var text: String = ""
    
    private var cancellables = [AnyCancellable]()
    private let entryStore: EntryStore
    
    init(entryStore: EntryStore) {
        self.entryStore = entryStore
        print(self, #function)
        
        cancellables.append(Timer.publish(every: 2, on: .main, in: .default).autoconnect().sink { [weak self] (_) in
            self?.text = "Random number: \(Int.random(in: 0..<100))"
        })
    }
}

