//
//  Network.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 12.08.23.
//

import Foundation

final class Network {

    // Daily articles request
    static func getDailyArticle() async throws -> ArticleResponse {
        let completeURL = getCompleteURL(forPath: API.EndPoint.daily)

        guard let url = completeURL else { throw RequestError.wrongURL(errorTitle: "Wrong URL") }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200...300: return try JSONDecoder().decode(ArticleResponse.self, from: data)
            default:
                let errorModel = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw RequestError.apiError(errorTitle: errorModel.fault.faultString)
            }
        } else {
            throw RequestError.failed
        }
    }

    // Weekly articles request
    static func getWeeklyArticle() async throws -> ArticleResponse {
        let completeURL = getCompleteURL(forPath: API.EndPoint.weekly)

        guard let url = completeURL else { throw RequestError.wrongURL(errorTitle: "Wrong URL") }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200...300: return try JSONDecoder().decode(ArticleResponse.self, from: data)
            default:
                let errorModel = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw RequestError.apiError(errorTitle: errorModel.fault.faultString)
            }
        } else {
            throw RequestError.failed
        }
    }

    // 30 days articles request, 30 days not month because month can also be 31 days
    static func getThirtyDaysArticle() async throws -> ArticleResponse {
        let completeURL = getCompleteURL(forPath: API.EndPoint.thirtyDays)

        guard let url = completeURL else { throw RequestError.wrongURL(errorTitle: "Wrong URL") }
        let (data, response) = try await URLSession.shared.data(from: url)

        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200...300: return try JSONDecoder().decode(ArticleResponse.self, from: data)
            default:
                let errorModel = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw RequestError.apiError(errorTitle: errorModel.fault.faultString)
            }
        } else {
            throw RequestError.failed
        }
    }

    static func downloadImageData(fromURL url: URL?) async throws -> Data {
        guard let url else { return Data() }
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200
        else { throw RequestError.failed }
        return data
    }

    private static func getCompleteURL(forPath path: String) -> URL? {
        guard let data = KeyChain.getAPIKey(service: Bundle.main.bundleIdentifier ?? "defaultService") else { return nil }
        let apiKey = String(decoding: data, as: UTF8.self)

        var urlComponents = URLComponents(string: API.baseURL)
        urlComponents?.path = "/\(path)"
        let queryItem = URLQueryItem(name: "api-key", value: apiKey)
        urlComponents?.queryItems = [queryItem]
        print(API.baseURL)
        return urlComponents?.url
    }
}
