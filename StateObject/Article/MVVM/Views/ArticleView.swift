//
//  ArticleView.swift
//  StateObject
//
//  Created by Roman Gojshik on 3.12.25.
//

import SwiftUI

struct ArticleView: View {
    @EnvironmentObject var dependencyContainer: DependencyContainer

    var body: some View {
        ArticlesViewContent(
            viewModel: ArticleViewModel(
                articleService: dependencyContainer.articleService
            )
        )
        .navigationTitle("Articles")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.orange, for: .navigationBar)   // цвет бара
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)        // белый текст/кнопки
        .tint(.white) 
    }
}

private struct ArticlesViewContent: View {
    @StateObject var viewModel: ArticleViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                
                List(viewModel.articles) { article in
                    Text(article.title)
                }
            }
        }
        .onAppear() {
            viewModel.loadArticles()
        }
    }
}
