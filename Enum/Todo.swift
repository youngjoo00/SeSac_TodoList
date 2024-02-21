//
//  Todo.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/18/24.
//

import Foundation

enum SelectMode {
    case create
    case update
}

enum Todo: String, CaseIterable {
    case title
    case deadLineDate
    case priority
    
    var displayString: String {
        switch self {
        case .title:
            return "제목"
        case .deadLineDate:
            return "마감일"
        case .priority:
            return "우선순위"
        }
    }
    
    // 뭔가 좀 많이 이상하지만 일단 구현
    static func returnStringList(todoData: TodoModel) -> [Int: String] {

        var dic: [Int: String] = [:]
        
        dic[0] = todoData.title
        dic[1] = todoData.memo
        dic[2] = DateManager.shared.formatDateString(date: todoData.deadLineDate)
        
        if let tag = todoData.tag {
            dic[3] = tag
        }
        
        dic[4] = Priority.checkedPriority(segmentIndex: todoData.priority)
        //dic[5] = list.title
        return dic
    }
}
