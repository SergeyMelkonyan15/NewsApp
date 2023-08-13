//
//  ArticleResponse.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 12.08.23.
//

import Foundation

struct ArticleResponse: Decodable {
    var status: String
    var copyright: String
    var numberOfResults: Int
    var results: [ArticleResult]

    enum CodingKeys: String, CodingKey {
        case status
        case copyright
        case numberOfResults = "num_results"
        case results
    }
}
