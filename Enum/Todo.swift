//
//  Todo.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/18/24.
//

import Foundation

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
}
