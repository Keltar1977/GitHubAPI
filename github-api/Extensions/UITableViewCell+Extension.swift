//
//  UITableViewCell+Extension.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/6/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self.self)
    }
}
