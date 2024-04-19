//
//  MyBucket.swift
//  BucketBuddy
//
//  Created by eunseou on 4/19/24.
//

import Foundation
import RealmSwift

class MyBucket: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var icon: String
    @Persisted var title: String
    @Persisted var deadline: Date
    @Persisted var iscomplete: Bool
    
    convenience init(
        icon: String,
        title: String,
        deadline: Date,
        iscomplete: Bool
    ) {
        self.init()
        self.icon = icon
        self.title = title
        self.deadline = deadline
        self.iscomplete = iscomplete
    }
}
