//
//  ArticleViewModel.swift
//  StateObject
//
//  Created by Roman Gojshik on 3.12.25.
//

import Foundation
import SwiftUI
import Combine

final class ArticleViewModel: ObservableObject {
    // @Published - свойства, которые автоматически обновляют UI
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Зависимость - сервис для загрузки данных (DI)
    private let articleService: ArticleService
    
    // Для хранения подписок Combine (чтобы они не отменялись)
    private var cancellables = Set<AnyCancellable>()
    
    init(articleService: ArticleService) {
        self.articleService = articleService
    }
    
    // Метод для загрузки статей
    func loadArticles() {
        isLoading = true
        errorMessage = nil
        
        articleService.fetchArticles()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] articles in
                    self?.articles = articles
                    self?.isLoading = false
                }
            )
            .store(in: &cancellables)
    }
}
