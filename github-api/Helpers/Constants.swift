//
//  Constants.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/5/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import Foundation

struct APIConstants {
    static let base = "https://api.github.com/graphql"
    
    static let authURL = "https://github.com/login/oauth"
    
    static let clientId  = "fb6d78487a2fe087ae20"
    
    static let clientSecret = "48e8d11c2b7115e4128047419068e2fbbf676e5a"
    
    static let redirectURI = "githubapi://authorize"
    
    static let scope = "user+repo"
}
