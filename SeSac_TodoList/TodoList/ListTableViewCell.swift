//
//  ListTableViewCell.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/20/24.
//

import UIKit
import Then

class ListTableViewCell: BaseTableViewCell {
    
    let mainImageView = UIImageView().then {
        $0.image = UIImage(systemName: "list.bullet.circle.fill")
        $0.tintColor = .white
    }
    
    let titleLabel = WhiteTitleLabel().then {
        $0.font = .systemFont(ofSize: 20)
    }
    
    let countLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17)
        $0.textColor = .systemGray4
    }
    
    override func configureHierarchy() {
        [
            mainImageView,
            titleLabel,
            countLabel,
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        mainImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.size.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(mainImageView.snp.trailing).offset(10)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(contentView).offset(-16)
        }
    }
    
    override func configureView() {
        let accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        accessoryView.tintColor = .systemGray5
        self.accessoryView = accessoryView
        
        backgroundColor = .darkGrayBackgroundColor
    }
    
    func updateCell(title: String, count: Int) {
        titleLabel.text = title
        countLabel.text = "\(count)"
    }
}
