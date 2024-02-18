//
//  AllListView.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/16/24.
//

import UIKit
import SnapKit
import Then

final class DetailTodoListView: BaseView {
    
    let navTitle = WhiteTitleLabel()
    
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(DetailTodoListTableViewCell.self, forCellReuseIdentifier: DetailTodoListTableViewCell.identifier)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 44
    }
    
    override func configureHierarchy() {
        [
            tableView
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
    }
}
