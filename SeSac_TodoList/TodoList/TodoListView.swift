//
//  TodoListView.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/14/24.
//

import UIKit
import Then

final class TodoListView: BaseView {

    let titleLabel = UILabel().then {
        $0.text = "전체"
        $0.textColor = .lightGray
        $0.font = .boldSystemFont(ofSize: 30)
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout()).then {
        $0.backgroundColor = .clear
        $0.register(TodoListCollectionViewCell.self, forCellWithReuseIdentifier: TodoListCollectionViewCell.identifier)
    }
    
    let addTodoBtn = UIButton().then {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "새로운 할 일"
        configuration.image = UIImage(systemName: "plus.circle.fill")
        configuration.baseForegroundColor = .systemBlue
        configuration.imagePadding = 10
        $0.configuration = configuration
    }
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .clear
        $0.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
    }
    
    override func configureHierarchy() {
        [
            titleLabel,
            collectionView,
            tableView,
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(250)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func createHeaderView() -> UIView {
        let headerView = UIView().then {
            $0.backgroundColor = .clear
        }
        
        let titleLabel = WhiteTitleLabel().then {
            $0.text = "나의 목록"
            $0.font = .boldSystemFont(ofSize: 25)
        }
        
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        return headerView
    }
}

extension TodoListView {
    
    static func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        
        let cellWidth = (UIScreen.main.bounds.width - (spacing * 3)) / 2
        let cellhieght: CGFloat = 100
        
        layout.itemSize = CGSize(width: cellWidth, height: cellhieght)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }
    
}
