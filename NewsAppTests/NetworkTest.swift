//
//  NetworkTest.swift
//  NewsAppTests
//
//  Created by Sergey Melkonyan on 14.08.23.
//

import XCTest
@testable import NewsApp

final class NetworkTest: XCTestCase {

    func testCompleteURLWithValidPathAndAPIKey() {
        let path = API.EndPoint.daily
        let resultURL = NetworkUtils.getCompleteURL(forPath: path)
        let wrongURLString = API.baseURL + API.EndPoint.daily + "?api-key=mockAPIKey" // replace baseURL with actual baseURL

        XCTAssertNotNil(resultURL)
        XCTAssertNotEqual(resultURL?.absoluteString, wrongURLString)
    }

    func testDownloadImageDataWithValidURL() async throws {

        let mockURL = URL(string: "https://static01.nyt.com/images/2023/03/31/us/beebuddy-promoimage/beebuddy-promoimage-thumbStandard-v4.jpg")!


        let data = try await NetworkUtils.downloadImageData(fromURL: mockURL)


        XCTAssertNotNil(data)
    }

}
