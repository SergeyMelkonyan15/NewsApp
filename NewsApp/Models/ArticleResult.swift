//
//  ArticleResult.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 12.08.23.
//

import Foundation

struct ArticleResult: Decodable {
    var source: String
    var publishedDate: String
    var byLine: String
    var title: String
    var abstract: String
    var section: String
    var type: String
    var media: [Media]

    enum CodingKeys: String, CodingKey {
        case source
        case publishedDate = "published_date"
        case byLine = "byline"
        case title
        case abstract
        case media
        case section
        case type
    }
}
