//
//  TodoModel.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/15/24.
//

import Foundation
import RealmSwift

class ListModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var regDate: Date
    @Persisted var todoList: List<TodoModel>
    
    convenience init(title: String, regDate: Date) {
        self.init()
        self.title = title
        self.regDate = regDate
        self.todoList = todoList
    }
}

class TodoModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String?
    @Persisted var regDate: Date
    @Persisted var deadLineDate: Date
    @Persisted var tag: String?
    @Persisted var priority: Int
    @Persisted var complete: Bool
    
    convenience init(title: String, memo: String? = nil, regDate: Date, deadLineDate: Date, tag: String? = nil, priority: Int, complete: Bool) {
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


