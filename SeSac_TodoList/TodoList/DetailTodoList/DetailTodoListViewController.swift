//
//  AllListViewController.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/16/24.
//

import UIKit
import RealmSwift
import FSCalendar

final class DetailTodoListViewController: BaseViewController {
    
    let mainView = DetailTodoListView()
    let todoRepository = Repository()
    
    var dataList: Results<TodoModel>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        readTodoData()
        
        configureView()
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        
        mainView.calendar.delegate = self
        mainView.calendar.dataSource = self
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 뷰가 완전히 보여지고 나서야 토스트가 나타난다!?
        // ViewDidLoad 같은 함수에서는 웬만하면 쓰지 말자..
        if dataList.count == 0 {
            showToast(message: "알림을 등록해보세요!")
        }
    }
    
    override func configureView() {
        mainView.fetchTodoBtn.addTarget(self, action: #selector(didFetchTodoBtnTapped), for: .touchUpInside)
    }
    
}

extension DetailTodoListViewController {
    
    func readTodoData() {
        dataList = todoRepository.fetchFilterTodoList(navTitleText: mainView.navTitle.text!)
        mainView.tableView.reloadData()
    }
    
    func configureNavigationBar() {
        
        navigationItem.titleView = mainView.navTitle
        
        // 액션 담아서 메뉴에 넣기
        var actionList: [UIAction] = []
        for i in Todo.allCases {
            let action = UIAction(title: "\(i.displayString) 순으로 보기") { _ in
                let data = self.todoRepository.fetchFilterTodoList(navTitleText: self.mainView.navTitle.text!)
                self.dataList = self.todoRepository.fetchSortColumn(table: data, i, ascending: true)
                self.mainView.tableView.reloadData()
            }
            
            actionList.append(action)
        }
        
        let action = UIAction(title: "우선순위", subtitle: "낮음") { _ in
            let data = self.todoRepository.fetchFilterTodoList(navTitleText: self.mainView.navTitle.text!)
            self.dataList = self.todoRepository.fetchFilterRowPriority(table: data)
            self.mainView.tableView.reloadData()
        }
        
        actionList.append(action)
        
        let menu = UIMenu(children: actionList)
        let rightBtnItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        
        navigationItem.rightBarButtonItem = rightBtnItem
    }
    
    @objc func didFetchTodoBtnTapped() {
        readTodoData()
    }
}

extension DetailTodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTodoListTableViewCell.identifier, for: indexPath) as! DetailTodoListTableViewCell
        
        let row = dataList[indexPath.row]
        let image = loadImageToDocument(filename: "\(row.id)")
        let isLastRow = (indexPath.row == dataList.count - 1)
        
        cell.updateCell(data: row, image: image, isLastRow: isLastRow)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = TodoViewController()
        vc.todoData = dataList[indexPath.row]
        vc.selectMode = .update
        vc.todoDelegate = self
        transition(viewController: vc, style: .presentNavigation)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
            print("즐겨찾기는 임시입니다.")
            print(action, view, completionHandler)
            completionHandler(true)
        }
        
        favorite.backgroundColor = .systemBlue
        favorite.image = UIImage(systemName: "star")
        
        let delete = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHandler in
            let item = self.dataList[indexPath.row]
            
            self.removeImageFromDocument(filename: "\(item.id)")
            self.todoRepository.deleteItem(item)
            
            tableView.reloadData()
            
            // 액션이 완료되었음을 시스템에 알리는 역할이라는데 없어도 문제는 없긴 하다..
            completionHandler(true)
        }
        
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash")
        
        //actions배열 인덱스 0이 오른쪽에 붙어서 나옴
        return UISwipeActionsConfiguration(actions:[delete, favorite])
    }
}

extension DetailTodoListViewController: checkBtnTappedDelegate {
    
    func cellCheckBtnTapped(cell: UITableViewCell) {
        // btn 을 눌렀을 때 감지한 셀의 indexPath 가져오기
        if let indexPath = mainView.tableView.indexPath(for: cell) {
            let item = dataList[indexPath.row]
            todoRepository.updateComplete(item)
            mainView.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
}

extension DetailTodoListViewController: PassTodoDelegate {
    
    func fetchTodoReceived() {
        mainView.tableView.reloadData()
    }
}

extension DetailTodoListViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return dataList.filter(DateManager.shared.query(queryType: .today, date: date)).count
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let data = todoRepository.fetchFilterTodoList(navTitleText: mainView.navTitle.text!)
        dataList = data.filter(DateManager.shared.query(queryType: .today, date: date))
        
        mainView.tableView.reloadData()
    }
}
