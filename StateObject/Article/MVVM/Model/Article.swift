//
//  Article.swift
//  StateObject
//
//  Created by Roman Gojshik on 3.12.25.
//

import Foundation

struct Article: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let body: String
    let publishedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        body: String,
        publishedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.publishedAt = publishedAt
    }
}
