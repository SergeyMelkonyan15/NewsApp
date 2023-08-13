//
//  NetworkUtils.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 13.08.23.
//

import Foundation

class NetworkUtils {

    static func getCompleteURL(forPath path: String) -> URL? {
        guard let data = KeyChain.getAPIKey(service: Bundle.main.bundleIdentifier ?? "defaultService") else { return nil }
        let apiKey = String(decoding: data, as: UTF8.self)

        var urlComponents = URLComponents(string: API.baseURL)
        urlComponents?.path = "/\(path)"
        let queryItem = URLQueryItem(name: "api-key", value: apiKey)
        urlComponents?.queryItems = [queryItem]
        return urlComponents?.url
    }

    static func downloadImageData(fromURL url: URL?) async throws -> Data {
           guard let url = url else { throw RequestError.failed }
           let request = URLRequest(url: url)
           let (data, response) = try await URLSession.shared.data(for: request)
           guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
               throw RequestError.failed
           }
           return data
       }

}
