//
//  RealmMigrator.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/5/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import Realm
import RealmSwift

class RealmMigrator {
    
    private static let schemaVersion: UInt64 = 3
    
    static func migrate() {
        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { _, oldSchemaVersion in
            if oldSchemaVersion < self.schemaVersion {
            }
        })
        Realm.Configuration.defaultConfiguration = config
        
        print(Realm.Configuration.defaultConfiguration)
    }
}
