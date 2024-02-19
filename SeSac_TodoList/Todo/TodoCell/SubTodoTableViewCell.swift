//
//  SubAddTodoTableViewCell.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/15/24.
//

import UIKit
import SnapKit

class SubTodoTableViewCell: BaseTableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        subTitleLabel.text = nil
        photoImageView.image = nil
    }
    
    let titleLabel = WhiteTitleLabel().then {
        $0.font = .systemFont(ofSize: 17)
    }
    
    let subTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .systemGray5
    }
    
    let photoImageView = UIImageView()
    
    override func configureHierarchy() {
        [
            titleLabel,
            subTitleLabel,
            photoImageView,
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-16)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-16)
            make.width.equalTo(contentView).dividedBy(3)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        let accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        accessoryView.tintColor = .systemGray5
        self.accessoryView = accessoryView
    }
}

