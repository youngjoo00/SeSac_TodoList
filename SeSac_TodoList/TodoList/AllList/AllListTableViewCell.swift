//
//  AllListTableViewCell.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/16/24.
//

import UIKit
import SnapKit
import Then

final class AllListTableViewCell: BaseTableViewCell {
    
    let checkBtn = UIButton().then {
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.borderWidth = 1
    }
    
    let titleTextField = UITextField().then {
        $0.textColor = .white
    }
    
    let memoTextView = UITextView().then {
        $0.textColor = .systemGray5
        $0.backgroundColor = .clear
        $0.font = .systemFont(ofSize: 16)
        // textContainerInset은 텍스트 뷰의 전체 내용에 대한 상단, 하단, 좌우 여백을 제어
        // lineFragmentPadding은 각 텍스트 라인의 좌우 여백만을 제어
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = 0
    }
    
    let deadLineLabel = WhiteTitleLabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    let tagLabel = WhiteTitleLabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    let priorityLabel = WhiteTitleLabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    override func configureHierarchy() {
        [
            checkBtn,
            titleTextField,
            memoTextView,
            deadLineLabel,
            tagLabel,
            priorityLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        checkBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleTextField).offset(2)
            make.leading.equalTo(contentView).offset(10)
            make.size.equalTo(20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.leading.equalTo(checkBtn.snp.trailing).offset(20)
            make.trailing.equalTo(contentView).offset(-16)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(titleTextField)
            make.height.equalTo(100)
        }
        
        deadLineLabel.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(titleTextField)
            make.height.equalTo(15)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(deadLineLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(titleTextField)
            make.height.equalTo(15)
        }
        
        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(titleTextField)
            make.height.equalTo(15)
            make.bottom.equalTo(contentView)
        }
    }
    
    override func configureView() {
        backgroundColor = .clear
        
    }
    
    override func layoutSubviews() {
        checkBtn.layer.cornerRadius = checkBtn.frame.width / 2
    }
}

