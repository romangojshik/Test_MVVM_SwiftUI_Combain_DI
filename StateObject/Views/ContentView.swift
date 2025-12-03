//
//  ContentView.swift
//  StateObject
//
//  Created by Roman Gojshik on 1.12.25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dependencyContainer: DependencyContainer
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                VStack(spacing: 32) {
                    Text(viewModel.refreshTimestamp)
                    Button(action: viewModel.refresh, label: {
                        Text("Refresh")
                    })
                }
                
                makeButtonPush()
                
                Spacer()
                
                BottomBarView(viewModel: BottomBarViewModel(entryStore: dependencyContainer.entryStore))
            }
            .padding()
            .toolbarBackground(Color.blue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .navigationTitle("Main")
            .tint(.white)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func makeButtonPush() -> some View {
        NavigationLink {
            DetailView()
        }
        label: {
            Text("Go to detail screen")
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DependencyContainer())
}
