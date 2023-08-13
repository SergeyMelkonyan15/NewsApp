//
//  Media.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 12.08.23.
//

import Foundation

struct Media: Decodable {
    // TODO replace the list of Metadata with "mediaImageSmall" and "mediaImageBig". Leaving this way to match the API response structure
    var mediaMetadata: [MetaData]

    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata"
    }
}
