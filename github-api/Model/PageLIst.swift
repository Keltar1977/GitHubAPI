//
//  PageLIst.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/7/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import Foundation

class PageList: NSObject {
    var currentPage = -1
    var pageSize = 15
    var nextPage: Int {
        currentPage += 1
        return currentPage
    }
}
