//
//  AllListView.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/16/24.
//

import UIKit
import Then
import FSCalendar

final class DetailTodoListView: BaseView {
    
    let navTitle = WhiteTitleLabel()
    
    let calendarBtn = UIButton().then {
        $0.tintColor = .white
        $0.contentVerticalAlignment = .fill
        $0.contentHorizontalAlignment = .fill
    }
    
    let fetchTodoBtn = UIButton().then {
        $0.setTitle("초기화", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    let calendar = FSCalendar().then {
        $0.isHidden = true
        $0.locale = Locale(identifier: "ko-KR")
        $0.backgroundColor = .darkGray
        $0.layer.cornerRadius = 16
        $0.appearance.weekdayTextColor = .white // 요일 색상
        $0.appearance.headerTitleFont = .boldSystemFont(ofSize: 20) //타이틀 폰트 크기
        $0.appearance.headerMinimumDissolvedAlpha = 0.0 //헤더 좌,우측 흐릿한 글씨 삭제
        $0.appearance.headerDateFormat = "YYYY년 M월" //날짜(헤더) 표시 형식
        $0.appearance.headerTitleColor = .white //2021년 1월(헤더) 색
        $0.appearance.titleWeekendColor = .systemBlue //주말 날짜 색
        $0.appearance.titleDefaultColor = .white //기본 날짜 색
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(DetailTodoListTableViewCell.self, forCellReuseIdentifier: DetailTodoListTableViewCell.identifier)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 44
    }
    
    override func configureHierarchy() {
        [
            calendarBtn,
            fetchTodoBtn,
            calendar,
            tableView,
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        calendarBtn.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(5)
            make.leading.equalTo(safeAreaLayoutGuide).offset(5)
            make.size.equalTo(30)
        }
        
        fetchTodoBtn.snp.makeConstraints { make in
            make.top.equalTo(calendarBtn)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(calendarBtn.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendarBtn.snp.bottom).offset(5)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        calendarBtn.setImage(UIImage(systemName: "calendar"), for: .normal)
        calendarBtn.addTarget(self, action: #selector(didCalendarBtnTapped), for: .touchUpInside)
    }
    
    @objc func didCalendarBtnTapped() {
        calendar.isHidden.toggle()
        
        // 캘린더의 히든 상태에 따라 제약조건 변경
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(calendar.isHidden ? calendarBtn.snp.bottom : calendar.snp.bottom).offset(5)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
}
