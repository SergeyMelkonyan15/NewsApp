//
//  Media.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 12.08.23.
//

import Foundation

struct Media: Decodable {
    var mediaMetadata: [MetaData]

    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata"
    }
}
