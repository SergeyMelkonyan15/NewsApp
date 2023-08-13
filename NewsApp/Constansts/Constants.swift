//
//  Constant.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 12.08.23.
//

import Foundation

enum API {
    static let baseURL = "https://api.nytimes.com/svc/mostpopular/v2/"

    enum EndPoint {
        static let daily = "svc/mostpopular/v2/viewed/1.json"
        static let weekly = "svc/mostpopular/v2/viewed/7.json"
        static let thirtyDays = "svc/mostpopular/v2/viewed/30.json"
    }
}

enum Filter: CaseIterable {
    case daily
    case weekly
    case thirtyDays
}

enum RequestError: Error {
    case failed
    case wrongURL(errorTitle: String)
    case apiError(errorTitle: String)
}