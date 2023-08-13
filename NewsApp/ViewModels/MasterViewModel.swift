//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 13.08.23.
//

import Foundation

class MasterViewModel {

    weak var delegate: MasterDelegate?
    private let masterArticlesRepository = MasterArticlesRepository()

    func getArticle(forType type: Filter) async {
        do {
            if let delegate {
                delegate.didStartDataLoading()
            }
            let article = try await masterArticlesRepository.getArticle(forType: type)
            if let delegate {
                delegate.didFetchArticle(article: article)
            }
        } catch let error {
            if let error = error as? RequestError {
                var errorMessage = ""

                switch error {
                case .wrongURL(let errorTitle):
                    errorMessage = errorTitle
                case .apiError(let errorTitle):
                    errorMessage = errorTitle
                case .failed:
                    errorMessage = "Generic Error"
                }
                if let delegate {
                    delegate.didGetError(errorMessage: errorMessage)
                }
            }

        }
    }

    func getImageURL(smallImageSize: ImageSize.RawValue, articleResult: ArticleResult) -> String? {
        var imageURL: String?
        guard let media = articleResult.media.first else { return nil }
        // find image of small size. Using for loop since the order of images may change in the json.
        // TODO change the model structure
        for (index, article) in media.mediaMetadata.enumerated() {
            if article.format == smallImageSize {
                imageURL = articleResult.media.first?.mediaMetadata[index].imageURL
                return imageURL
            }
        }
        return imageURL
    }


}

