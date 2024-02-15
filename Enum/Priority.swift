//
//  CheckedPriority.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/15/24.
//

import Foundation

enum Priority {
    
    static func checkedPriority(segmentIndex: Int) -> String {
        switch segmentIndex {
        case 0:
            return "우선순위: 낮음"
        case 1:
            return "우선순위: 보통"
        case 2:
            return "우선순위: 높음"
        default:
            return "우선순위: 없음"
        }
    }
    
}

