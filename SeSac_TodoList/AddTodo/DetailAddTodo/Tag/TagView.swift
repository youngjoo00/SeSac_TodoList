//
//  TagView.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/15/24.
//

import UIKit
import SnapKit
import Then

class TagView: BaseView {
    
    let navTitle = WhiteTitleLabel().then {
        $0.text = "태그"
    }
    
    let textField = UserInputTextField().then {
        $0.setPlaceholder(placeholder: "태그를 입력해보세요", color: .systemGray5)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    override func configureHierarchy() {
        [
            textField
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        
    }
    
}
