//
//  PassDataDelegate.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/19/24.
//

import Foundation

protocol PassTodoDelegate {
    func fetchTodoReceived()
}

protocol PassDataDelegate {
    func priorityReceived(segmentIndex: Int, section: Int)
}
