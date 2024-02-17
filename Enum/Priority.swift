//
//  CheckedPriority.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/15/24.
//

import Foundation

enum Priority {
    
    static func checkedPriority(segmentIndex: Int?) -> String {
        switch segmentIndex {
        case 0:
            return "없음"
        case 1:
            return "낮음"
        case 2:
            return "보통"
        case 3:
            return "높음"
        default:
            return ""
        }
    }
    
}

