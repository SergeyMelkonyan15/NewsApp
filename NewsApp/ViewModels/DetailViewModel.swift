//
//  DetailViewModel.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 13.08.23.
//

import Foundation

final class DetailViewModel {
    private var articles: ArticleResult?

    func updateArticles(withArticles articles: ArticleResult) {
        self.articles = articles
    }

    func getArticles() -> ArticleResult? {
        return articles
    }

    func getImage(withURL url: String?) async -> Data? {
        guard let url else { return nil }
        do {
            let imageData = try await Network.downloadImageData(fromURL: URL(string: url))
            return imageData
        } catch {
            return nil
        }
    }
}
