//
//  DateView.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/15/24.
//

import UIKit
import SnapKit
import Then

class DateView: BaseView {
    
    let navTitle = WhiteTitleLabel().then {
        $0.text = "마감일"
    }
    
    let datePickerView = UIDatePicker().then {
        $0.preferredDatePickerStyle = .inline
        $0.backgroundColor = .systemGray5
        $0.locale = Locale(identifier: "ko-KR")
    }
    
    override func configureHierarchy() {
        [
            datePickerView
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        datePickerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
    }
    
}
