//
//  MasterArticlesRepository.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 13.08.23.
//

import Foundation

class MasterArticlesRepository {
    func getArticle(forType type: Filter) async throws -> ArticleResponse {
        let path: String
        switch type {
        case .daily:
            path = API.EndPoint.daily
        case .weekly:
            path = API.EndPoint.weekly
        case .thirtyDays:
            path = API.EndPoint.thirtyDays
        }

        guard let completeURL = NetworkUtils.getCompleteURL(forPath: path) else {
            throw RequestError.wrongURL(errorTitle: "Wrong URL")
        }
        let (data, response) = try await URLSession.shared.data(from: completeURL)
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200...300:
                return try JSONDecoder().decode(ArticleResponse.self, from: data)
            default:
                let errorModel = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw RequestError.apiError(errorTitle: errorModel.fault.faultString)
            }
        } else {
            throw RequestError.failed
        }
    }
}
