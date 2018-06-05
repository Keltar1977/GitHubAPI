//
//  LoginViewController.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/5/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import Moya
import RxCocoa
import Moya_ObjectMapper

class LoginViewController: UIViewController {
    
    let provider = APIProvider.provider()
    let disposeBag = DisposeBag()
    var viewModel: LoginViewModel!
    @IBOutlet weak var webView: LoginWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
        webView.delegate = self
        webView.requestForLogin()
    }
    
    func setupRx() {
        viewModel = LoginViewModel(provider: provider)
        viewModel.tokenObservable
            .subscribe(onNext: { (token) in
                KeychainService.token = token
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let requestURLString = request.url?.absoluteString else { return false }
        print(requestURLString)
        if requestURLString.hasPrefix(APIConstants.redirectURI) {
            if let range: Range<String.Index> = requestURLString.range(of: "?code=") {
                let code = String(requestURLString[range.upperBound...])
                viewModel.codeRelay.accept(code)
            }
            return false
        } else {
            return true
        }
    }
}
