//
//  AllListTableViewCell.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/16/24.
//

import UIKit
import Then

/*
 weak 이해하기
 1. Swift에서 weak 키워드는 메모리 관리를 위해 사용된다.
 2. weak는 참조 카운트를 증가시키지 않으므로 순환 참조를 방지할 수 있다.
 3. weak는 클래스 인스턴스에만 사용할 수 있다.
 
 weak 키워드를 프로토콜에 사용하려면 프로토콜이 클래스에만 구현될 수 있도록 명시해야함
 이를 위해 프로토콜 선언 시 : AnyObject 또는 : class를 추가한다.
 */

protocol checkBtnTappedDelegate: AnyObject {
    func cellCheckBtnTapped(cell: UITableViewCell)
}

final class DetailTodoListTableViewCell: BaseTableViewCell {
    
    // prepareForReuse 함수를 통해 재사용 되기 전에 초기화 시켜주도록 함
    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        memoLabel.text = nil
        deadLineLabel.text = nil
        tagLabel.text = nil
        priorityLabel.text = nil
        lineView.isHidden = false
        photoImageView.image = nil
    }
    
    weak var delegate: checkBtnTappedDelegate?
    
    private let checkBtn = UIButton().then {
        $0.tintColor = .systemGray5
        $0.contentMode = .scaleAspectFill
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    private let titleLabel = WhiteTitleLabel()
    
    private let memoLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17)
        $0.textColor = .systemGray5
        $0.numberOfLines = 10
    }
    
    private let deadLineLabel = WhiteTitleLabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    private let tagLabel = WhiteTitleLabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textColor = .systemBlue
    }
    
    private let priorityLabel = WhiteTitleLabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    private let photoImageView = UIImageView()
    
    private let lineView = LineView()
    
    override func configureHierarchy() {
        [
            checkBtn,
            titleLabel,
            stackView,
            lineView,
            photoImageView
        ].forEach { contentView.addSubview($0) }
        
        [
            memoLabel,
            deadLineLabel,
            tagLabel,
            priorityLabel,
        ].forEach { stackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        checkBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel).offset(2)
            make.leading.equalTo(contentView).offset(10)
            make.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.leading.equalTo(checkBtn.snp.trailing).offset(20)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.size.equalTo(80)
            make.trailing.equalTo(contentView).offset(-16)
        }
    }
    
    override func configureView() {
        backgroundColor = .clear
        
        // 버튼이 만들어지고 난 뒤, addTarget 을 진행해야 한다.
        checkBtn.addTarget(self, action: #selector(checkBtnTapped), for: .touchUpInside)
    }
    
    @objc func checkBtnTapped() {
        delegate?.cellCheckBtnTapped(cell: self)
    }
}

extension DetailTodoListTableViewCell {
    
    func updateCell(data: TodoModel, image: UIImage?, isLastRow: Bool) {
        titleLabel.text = data.title
        memoLabel.text = data.memo
        deadLineLabel.text = DateManager.shared.formatDateString(date: data.deadLineDate)
        
        if let tag = data.tag, !tag.isEmpty {
            tagLabel.text = "#\(tag)"
        }
        
        if data.priority != 0 {
            priorityLabel.text = "우선순위 : \(Priority.checkedPriority(segmentIndex: data.priority))"
        }
        
        if data.complete {
            checkBtn.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        } else {
            checkBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        }

        photoImageView.image = image

        
        lineView.isHidden = isLastRow
    }
}
