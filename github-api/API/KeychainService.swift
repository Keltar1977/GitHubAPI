//
//  KeychainService.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/5/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainService {
    private static var keychain: Keychain {
        return Keychain(service: "github-api")
    }
    private static let tokenKey = "token"
    
    static var token: String {
        get {
            return keychain[tokenKey] ?? ""
        }
        set {
            keychain[tokenKey] = newValue
        }
    }
    
    static func clearKeychain() {
        do {
            try keychain.removeAll()
        } catch {
            print(exception())
        }
    }
}
