//
//  AddTodoTableViewCell.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/14/24.
//

import UIKit
import SnapKit
import Then

final class TitleMemoTableViewCell: BaseTableViewCell {
    
    let titleTextField = UserInputTextField().then {
        $0.setPlaceholder(placeholder: "제목", color: .systemGray5)
        $0.font = .systemFont(ofSize: 18)
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
    }
    
    let lineView = LineView()
    
    let memoTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.text = "메모"
        $0.textColor = .systemGray5
        $0.font = .systemFont(ofSize: 18)
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
    }
    
    override func configureHierarchy() {
        [
            titleTextField,
            lineView,
            memoTextView,
        ].forEach { contentView.addSubview($0)}
    }
    
    override func configureLayout() {
        titleTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(44)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom)
            make.leading.equalTo(contentView).inset(16)
            make.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalTo(contentView)
            make.height.equalTo(100)
        }
    }
    
    override func configureView() {
    }
}


