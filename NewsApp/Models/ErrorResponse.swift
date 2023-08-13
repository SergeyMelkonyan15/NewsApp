//
//  ErrorResponse.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 13.08.23.
//

import Foundation

struct ErrorResponse: Decodable {
    var fault: Fault
}

struct Fault: Decodable {
    var faultString: String
    var detail: Detail

    enum CodingKeys: String, CodingKey {
        case faultString = "faultstring"
        case detail
    }
}

struct Detail: Decodable {
    var errorCode: String

    enum CodingKeys: String, CodingKey {
        case errorCode = "errorcode"
    }
}
