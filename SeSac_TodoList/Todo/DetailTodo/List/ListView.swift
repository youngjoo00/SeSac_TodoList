//
//  ListView.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/21/24.
//

import UIKit
import Then

final class ListView: BaseView {
    
    let navTitle = WhiteTitleLabel().then {
        $0.text = "목록"
    }
    
    let titleLabel = WhiteTitleLabel()
    
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "listCell")
    }
    
    override func configureHierarchy() {
        [
            titleLabel,
            tableView
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}
