//
//  Utils.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 26.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation
import CommonCrypto

class Utils {
    static func calculateHash(combining strings: [String]) -> String {
        return self.getHash(strings.joined())
    }
    
    private static func getHash(_ phrase: String) -> String {
        let data = phrase.data(using: String.Encoding.utf8)!
        let length = Int(CC_SHA256_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined(separator: "")
    }
}
