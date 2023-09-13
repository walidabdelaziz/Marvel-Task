//
//  API.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import Foundation
import CommonCrypto

class APISettings{
    static func generateMarvelAPIHash(timestamp: String, privateKey: String, publicKey: String) -> String {
        let input = timestamp + privateKey + publicKey
        if let data = input.data(using: .utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            _ = data.withUnsafeBytes {
                CC_MD5($0.baseAddress, CC_LONG(data.count), &digest)
            }
            return digest.map { String(format: "%02hhx", $0) }.joined()
        }
        return ""
    }

    static func getCurrentUnixTimestamp() -> String {
        let timestamp = Date().timeIntervalSince1970
        return String(format: "%.0f", timestamp)
    }
}
