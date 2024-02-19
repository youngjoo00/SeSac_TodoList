//
//  DetailTodoList.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/19/24.
//

import UIKit

enum DetailTodoList: String, CaseIterable {
    case title
    case date = "마감일"
    case tag = "태그"
    case priority = "우선 순위"
    case addImage = "이미지 추가"
    
    var viewController: UIViewController {
        switch self {
        case .title:
            return ViewController()
        case .date:
            return DateViewController()
        case .tag:
            return TagViewController()
        case .priority:
            return PriorityViewController()
        case .addImage:
            return AddImageViewController()
        }
    }
    
}
