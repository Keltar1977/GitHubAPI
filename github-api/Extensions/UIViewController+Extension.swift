//
//  UIViewController+Extension.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/5/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        return String(describing: self.self)
    }
    
    static var loadFromNib: UIViewController {
        return self.init(nibName: self.identifier, bundle: nil)
    }
}

