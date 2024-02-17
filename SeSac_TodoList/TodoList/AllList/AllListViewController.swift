//
//  AllListViewController.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/16/24.
//

import UIKit
import RealmSwift

final class AllListViewController: BaseViewController {
    
    let mainView = AllListView()
    
    var allList: Results<TodoModel>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        
        readTodoData()
    }
    
}

extension AllListViewController {
    
    func readTodoData() {
        
        let realm = try! Realm()
        
        allList = realm.objects(TodoModel.self).sorted(byKeyPath: "regDate", ascending: true)
    
        if allList.count == 0 {
            showToast(message: "알림을 등록해보세요!")
        }
        
        mainView.tableView.reloadData()
    }
    
    func configureNavigationBar() {

        let realm = try! Realm()
        
        let temp = realm.objects(TodoModel.self)
        navigationItem.titleView = mainView.navTitle

        let deadlineAction = UIAction(title: "마감일 순으로 보기") { _ in
            self.allList = temp.sorted(byKeyPath: "deadLineDate", ascending: true)
            self.mainView.tableView.reloadData()
        }
        
        let titleAction = UIAction(title: "제목 순으로 보기") { _ in
            self.allList = temp.sorted(byKeyPath: "title", ascending: true)
            self.mainView.tableView.reloadData()
        }

        let priorityAction = UIAction(title: "우선순위 낮음만 보기") { _ in
            self.allList = temp.where {
                $0.priority == 1
            }
            self.mainView.tableView.reloadData()
        }
        
        let menu = UIMenu(children: [deadlineAction, titleAction, priorityAction])
        let rightBtnItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        
        navigationItem.rightBarButtonItem = rightBtnItem
    }

}
extension AllListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllListTableViewCell.identifier, for: indexPath) as! AllListTableViewCell
        
        let row = allList[indexPath.row]
        
        if row.complete {
            cell.checkBtn.backgroundColor = .white
        } else {
            cell.checkBtn.backgroundColor = .clear
        }
        cell.titleTextField.text = row.title
        cell.memoTextView.text = row.memo
        cell.deadLineLabel.text = row.deadLineDate
        
        if let tag = row.tag {
            cell.tagLabel.text = "#\(tag)"
        }
        
        cell.priorityLabel.text = "우선순위 : \(Priority.checkedPriority(segmentIndex: row.priority))"
        return cell
    }
    
}
