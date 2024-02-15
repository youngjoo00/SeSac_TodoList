//
//  TodoListCollectionViewCell.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/14/24.
//

import UIKit
import SnapKit
import Then

final class TodoListCollectionViewCell: BaseCollectionViewCell {
    
    let mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    let countLabel = WhiteTitleLabel().then {
        $0.font = .boldSystemFont(ofSize: 30)
    }
    let titleLabel = UILabel().then {
        $0.textColor = .systemGray5
    }
    
    override func configureHierarchy() {
        [
            mainImageView,
            countLabel,
            titleLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        mainImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).offset(10)
            make.size.equalTo(50)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.trailing.equalTo(contentView).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
            make.leading.equalTo(contentView).offset(16)
            make.height.equalTo(18)
        }
    }
    
    override func configureView() {
        backgroundColor = .darkGray
        layer.cornerRadius = 16
    }
}
