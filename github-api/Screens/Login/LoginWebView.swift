//
//  LoginWebView.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/5/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import UIKit
import WebKit

class LoginWebView: UIWebView {

    func requestForLogin() {
        let authURL = String(format: "%@/authorize?client_id=%@&scope=%@",
                             arguments: [APIConstants.authURL, APIConstants.clientId, APIConstants.scope])
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        loadRequest(urlRequest)
    }

}
