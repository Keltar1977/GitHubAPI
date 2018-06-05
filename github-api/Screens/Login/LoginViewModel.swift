//
//  LoginViewModel.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/5/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya


class LoginViewModel {
    
    let codeRelay: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let tokenObservable: Observable<String>!
    
    init(provider: MoyaProvider<GithubAPI>) {
        tokenObservable = codeRelay.asObservable()
            .flatMapLatest({ (code) -> Observable<Response> in
                guard let code = code else { return Observable.empty() }
                return provider.rx.request(GithubAPI.authorization(code: code)).asObservable()
            })
            .mapJSON()
            .flatMapLatest({ (response) -> Observable<String> in
                guard let dictionary = response as? [String: String] else { return Observable.empty() }
                return Observable.just(dictionary["access_token"] ?? "")
            })
    }
}
