//
//  KeyChain.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 13.08.23.
//

import Foundation
import Security

class KeyChain {
    enum KeyChainError: Error {
        case duplicate
        case unknown(OSStatus)
    }

    static func save(apiKey: Data, service: String) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: service as AnyObject,
            kSecValueData as String: apiKey as AnyObject
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status != errSecDuplicateItem else {
            throw KeyChainError.duplicate
        }

        guard status == errSecSuccess else {
            throw KeyChainError.unknown(status)
        }

        print("saved")
    }

    static func getAPIKey(service: String) -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: service as AnyObject,
            kSecReturnData as String: kCFBooleanTrue
        ]

        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        return result as? Data
    }
}
