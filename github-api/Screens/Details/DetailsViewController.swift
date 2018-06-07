//
//  DetailsViewController.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/6/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var webView: CustomWebView!
    private var urlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        webView.makeRequest(with: urlString)
    }
    
    func setUrlString(value: String) {
        urlString = value
    }

    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

}
