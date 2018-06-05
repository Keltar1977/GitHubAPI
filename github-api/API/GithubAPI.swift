//
//  GithubAPI.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/5/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import Foundation
import Moya
import RealmSwift
import ObjectMapper

enum GithubAPI {
    case authorization(code: String)
    case searchRepo(query: String, page: Int, count: Int)
}

extension GithubAPI: TargetType {
    var baseURL: URL {
        var baseString = ""
        switch self {
        case .authorization:
            baseString = APIConstants.authURL
        case .searchRepo:
            baseString = APIConstants.base
        }
        guard let url = URL(string: baseString) else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .authorization:
            return "access_token"
        case .searchRepo:
            return "search/repositories"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .authorization:
            return .post
        case .searchRepo:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .authorization(let code):
            return .requestParameters(parameters: ["client_id": APIConstants.clientId,
                                                   "client_secret": APIConstants.clientSecret,
                                                   "code": code],
                                      encoding: JSONEncoding.default)
        case .searchRepo(let query, let page, let count):
            return .requestParameters(parameters: ["page": page,
                                                   "per_page": count,
                                                   "q": query,
                                                   "sort": "stars"],
                                      encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .authorization:
            return ["Accept": "application/json"]
        case .searchRepo:
            return ["Authorization": "bearer " + KeychainService.token]
        }
    }
}
