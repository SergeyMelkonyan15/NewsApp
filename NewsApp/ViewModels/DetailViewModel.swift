//
//  DetailViewModel.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 13.08.23.
//

import Foundation

final class DetailViewModel {

    // article to be shown
    private var article: ArticleResult?

    func updateTappedArticle(withArticle article: ArticleResult) {
        self.article = article
    }

    func getArticle() -> ArticleResult? {
        return article
    }

    func getImage(withURL url: String?) async -> Data? {
        guard let url else { return nil }
        do {
            let imageData = try await NetworkUtils.downloadImageData(fromURL: URL(string: url))
            return imageData
        } catch {
            return nil
        }
    }

    func getImageURL(bigImageSize: ImageSize.RawValue) -> String? {
        guard let article else { return nil}

        var imageURL: String?
        guard let media = article.media.first else { return nil }
        for (index, metadata) in media.mediaMetadata.enumerated() {
            if metadata.format == bigImageSize {
                imageURL = article.media.first?.mediaMetadata[index].imageURL
                return imageURL
            }
        }
        return imageURL
    }
}
