//
//  PriorityView.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/15/24.
//

import UIKit
import SnapKit
import Then

final class PriorityView: BaseView {
    
    let navTitle = WhiteTitleLabel().then {
        $0.text = "우선 순위"
    }
    
    let segmentControl = UISegmentedControl().then {
        $0.insertSegment(withTitle: "없음", at: 0, animated: true)
        $0.insertSegment(withTitle: "낮음", at: 1, animated: true)
        $0.insertSegment(withTitle: "보통", at: 2, animated: true)
        $0.insertSegment(withTitle: "높음", at: 3, animated: true)
        $0.selectedSegmentTintColor = .systemBlue

        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
    }
    
    override func configureHierarchy() {
        [
            segmentControl
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        
    }
    
}
