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

protocol PassListDelegate {
    func fetchListReceived()
}

protocol PassDataDelegate {
    func priorityReceived(segmentIndex: Int, section: Int)
}

protocol PassListStringDelegate {
    func listReceived(list: ListModel, section: Int)
}
