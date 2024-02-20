//
//  AddListView.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/20/24.
//

import UIKit
import Then

final class AddListView: BaseView {
    
    let navTitle = WhiteTitleLabel().then {
        $0.text = "목록 추가"
    }
    
    let backgroundView = UIView().then {
        $0.backgroundColor = .darkGray
        $0.layer.cornerRadius = 8
    }
    
    let mainImageView = UIImageView().then {
        $0.image = UIImage(systemName: "list.bullet.circle.fill")
        $0.tintColor = .white
    }
    
    let listTextField = UITextField().then {
        $0.backgroundColor = .systemGray
        $0.setPlaceholder(placeholder: "목록 이름", color: .systemGray5)
        $0.layer.cornerRadius = 8
        $0.textAlignment = .center
        $0.configureView()
    }
    
    override func configureHierarchy() {
        [
            backgroundView,
            mainImageView,
            listTextField,
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(200)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        listTextField.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(backgroundView).inset(16)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
    }
}
