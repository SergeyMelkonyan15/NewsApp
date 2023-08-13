//
//  MetaData.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 12.08.23.
//

import Foundation

struct MetaData: Decodable {
    var imageURL: String
    var format: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "url"
        case format
    }
}
