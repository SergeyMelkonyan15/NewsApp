//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 13.08.23.
//

import Foundation

class HomeViewModel {

    weak var delegate: HomeViewModelDelegate?

    func getArticle(forType type: Filter) async {
        configureKeyChain()

        switch type {
        case .daily:
            do {
                let article = try await Network.getDailyArticle()
                delegate?.didFetchArticle(article: article)
            } catch let error {
                if let error = error as? RequestError {
                    switch error {
                    case .failed:
                        delegate?.didGetError(errorMessage: "Failed")
                    case .wrongURL(let errorTitle):
                        delegate?.didGetError(errorMessage: errorTitle)
                    case .apiError(let errorTitle):
                        delegate?.didGetError(errorMessage: errorTitle)
                    }
                }
            }
        case .weekly:
            do {
                let article = try await Network.getWeeklyArticle()
                delegate?.didFetchArticle(article: article)
            } catch(let error) {
                if let error = error as? RequestError {
                    switch error {
                    case .failed:
                        delegate?.didGetError(errorMessage: "Failed")
                    case .wrongURL(let errorTitle):
                        delegate?.didGetError(errorMessage: errorTitle)
                    case .apiError(let errorTitle):
                        delegate?.didGetError(errorMessage: errorTitle)
                    }
                }
            }
        case .thirtyDays:
            do {
                let article = try await Network.getThirtyDaysArticle()
                delegate?.didFetchArticle(article: article)
            } catch(let error) {
                if let error = error as? RequestError {
                    switch error {
                    case .failed:
                        delegate?.didGetError(errorMessage: "Failed")
                    case .wrongURL(let errorTitle):
                        delegate?.didGetError(errorMessage: errorTitle)
                    case .apiError(let errorTitle):
                        delegate?.didGetError(errorMessage: errorTitle)
                    }
                }
            }
        }
    }

    private func configureKeyChain() {
        do {
            try KeyChain.save(
                apiKey: "KCgxWvz3oEqgDC6ZaCOXpc24JKhT44vC".data(using: .utf8) ?? Data(),
                service: Bundle.main.bundleIdentifier ?? "defaultID"
            )
        } catch {
            print(error)
        }
    }
}
