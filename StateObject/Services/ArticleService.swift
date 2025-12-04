//
//  ArticleService.swift
//  StateObject
//
//  Created by Roman Gojshik on 3.12.25.
//

import Foundation
import Combine

protocol ArticleService {
    //AnyPublisher — это тип из Combine, который представляет асинхронный поток данных.
    //AnyPublisher<[Article], Error> — тип возвращаемого значения
    func fetchArticles() -> AnyPublisher<[Article], Error>
}

final class MockArticleService: ArticleService {
    func fetchArticles() -> AnyPublisher<[Article], Error> {
        let articles: [Article] = [
            Article(
                title: "StateObject и MVVM",
                subtitle: "Управление жизненным циклом ViewModel",
                body: "Длинный текст статьи про @StateObject и MVVM..."
            ),
            Article(
                title: "SwiftUI View Lifecycle",
                subtitle: "Appear, Update, Disappear",
                body: "Разбор жизненного цикла View в SwiftUI..."
            ),
            Article(
                title: "Combine в MVVM",
                subtitle: "Работа с Publisher и @Published",
                body: "Как использовать Combine в связке с MVVM..."
            )
        ]
        
        //Just — создание Publisher
        // Эмулируем сетевой запрос с задержкой 1 секунда
        return Just(articles)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            //.eraseToAnyPublisher() — это метод Combine, который «стирает» конкретный тип Publisher и возвращает универсальный AnyPublisher.
            .eraseToAnyPublisher()
    }
}
