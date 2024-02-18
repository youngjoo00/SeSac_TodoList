//
//  AddTodoView.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/14/24.
//

import UIKit
import SnapKit
import Then

final class AddTodoView: BaseView {
    
    let navTitle = WhiteTitleLabel().then {
        $0.text = "새로운 할 일"
    }
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .clear
        $0.register(TitleMemoTableViewCell.self, forCellReuseIdentifier: TitleMemoTableViewCell.identifier)
        $0.register(SubTodoTableViewCell.self, forCellReuseIdentifier: SubTodoTableViewCell.identifier)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 44
    }
    
    override func configureHierarchy() {
        [
            tableView,
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
