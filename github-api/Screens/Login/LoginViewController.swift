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
    
    private let provider = APIProvider.provider()
    private let disposeBag = DisposeBag()
    private var viewModel: LoginViewModel!
    @IBOutlet weak var webView: CustomWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
        webView.delegate = self
        webView.requestForLogin()
    }
    
    private func setupRx() {
        viewModel = LoginViewModel(provider: provider)
        viewModel.tokenObservable
            .subscribe(onNext: { [unowned self] (token) in
                KeychainService.token = token
                NavigationRouter.showSearchViewController(from: self)
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
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        NavigationRouter.showSearchViewController(from: self)                 // Offline mode 
    }
}
