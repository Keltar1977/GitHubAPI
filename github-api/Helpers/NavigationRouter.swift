//
//  NavigationRouter.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/5/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import UIKit

class NavigationRouter {
    static func showSearchViewController(from sourceVC: UIViewController) {
        let searchVC = SearchViewController.loadFromNib
        let navController = UINavigationController(rootViewController: searchVC)
        sourceVC.present(navController, animated: true, completion: nil)
    }
    
    static func showDetails(from sourceVC: SearchViewController, with urlString: String) {
        guard let popoverContent = DetailsViewController.loadFromNib as? DetailsViewController else { return }
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: sourceVC.view.frame.width * 0.8,
                                                     height: sourceVC.view.frame.height * 0.8)
        popover?.delegate = sourceVC
        popover?.sourceView = sourceVC.view
        popover?.permittedArrowDirections = .init(rawValue: 0)
        popover?.sourceRect = sourceVC.view.bounds
        popoverContent.setUrlString(value: urlString)
        sourceVC.present(nav, animated: true, completion: nil)
    }
}
