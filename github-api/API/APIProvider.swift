//
//  APIProvider.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/5/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import Foundation
import Moya

struct APIProvider {
    static func provider() -> MoyaProvider<GithubAPI> {
        let endpointClosure = { (target: GithubAPI) -> Endpoint in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            let sampleResponse: Endpoint.SampleResponseClosure = { .networkResponse(200, target.sampleData) }
            var endpoint: Endpoint = Endpoint(url: url,
                                              sampleResponseClosure: sampleResponse,
                                              method: target.method,
                                              task: target.task,
                                              httpHeaderFields: target.headers)
            switch target {
            case .authorization:
                break
            default:
                endpoint = endpoint.adding(newHTTPHeaderFields: ["Authorization": "bearer " + KeychainService.token])
            }
            return endpoint
        }
        
        let plugins: [PluginType] = [NetworkLoggerPlugin(verbose: true)]
        
        return MoyaProvider<GithubAPI>(endpointClosure: endpointClosure, plugins: plugins)
    }
}
