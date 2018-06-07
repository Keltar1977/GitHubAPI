//
//  Repository.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/5/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import Realm

class Repository: Object, Mappable {
    
    
    @objc dynamic var ID: Int = -1
    @objc dynamic var fullName: String = ""
    @objc dynamic var repoDescription: String = ""
    @objc dynamic var svnURL: String = ""
    @objc dynamic var stars: Int = 0
    
    required init?(map: Map) {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    override class func primaryKey() -> String? {
        return "ID"
    }
    
    required init() {
        super.init()
    }
    
    // MARK: - Mapping
    func mapping(map: Map) {
        ID <- map["id"]
        fullName <- map["full_name"]
        repoDescription <- map["description"]
        svnURL <- map["svn_url"]
        stars <- map["stargazers_count"]
    }
}
