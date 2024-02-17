//
//  TodoModel.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/15/24.
//

import Foundation
import RealmSwift

class TodoModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String?
    @Persisted var regDate: Date
    @Persisted var deadLineDate: String
    @Persisted var tag: String?
    @Persisted var priority: Int
    @Persisted var complete: Bool
    
    convenience init(title: String, memo: String? = nil, regDate: Date, deadLineDate: String, tag: String? = nil, priority: Int, complete: Bool) {
        self.init()
        self.title = title
        self.memo = memo
        self.regDate = regDate
        self.deadLineDate = deadLineDate
        self.tag = tag
        self.priority = priority
        self.complete = complete
    }
}
