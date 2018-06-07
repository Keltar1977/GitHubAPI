//
//  LoginWebView.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/5/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import UIKit
import WebKit

class CustomWebView: UIWebView {

    func requestForLogin() {
        let authString = String(format: "%@/authorize?client_id=%@&scope=%@",
                             arguments: [APIConstants.authURL, APIConstants.clientId, APIConstants.scope])
        makeRequest(with: authString)
        
    }
    
    func makeRequest(with requestString: String) {
        if let requestURL = URL.init(string: requestString) {
            let urlRequest =  URLRequest.init(url: requestURL)
            loadRequest(urlRequest)
        }
    }

}
