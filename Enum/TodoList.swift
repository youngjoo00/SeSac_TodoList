//
//  TodoList.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/17/24.
//

import UIKit

enum TodoList: String, CaseIterable {
    case today = "오늘"
    case expected = "예정"
    case all = "전체"
    case complete = "완료됨"
    
    var image: UIImage? {
        switch self {
        case .today:
            return UIImage(systemName: "calendar")
        case .expected:
            return UIImage(systemName: "calendar.badge.exclamationmark")
        case .all:
            return UIImage(systemName: "apple.logo")
        case .complete:
            return UIImage(systemName: "checkmark")
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .today:
            return ViewController()
        case .expected:
            return ViewController()
        case .all:
            return AllListViewController()
        case .complete:
            return ViewController()
        }
    }
    
}
