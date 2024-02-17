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
    let todoRepository = TodoTableRepository()
    
    var dataList: Results<TodoModel>!
    
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
        
        dataList = todoRepository.fetch()
    
        if dataList.count == 0 {
            showToast(message: "알림을 등록해보세요!")
        }
        
        mainView.tableView.reloadData()
    }
    
    func configureNavigationBar() {

        navigationItem.titleView = mainView.navTitle

        let temp = todoRepository.fetch()

        let deadlineAction = UIAction(title: "마감일 순으로 보기") { _ in
            self.dataList = temp.sorted(byKeyPath: "deadLineDate", ascending: true)
            self.mainView.tableView.reloadData()
        }
        
        let titleAction = UIAction(title: "제목 순으로 보기") { _ in
            self.dataList = temp.sorted(byKeyPath: "title", ascending: true)
            self.mainView.tableView.reloadData()
        }

        let priorityAction = UIAction(title: "우선순위 낮음만 보기") { _ in
            self.dataList = temp.where {
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
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllListTableViewCell.identifier, for: indexPath) as! AllListTableViewCell
        
        print("dataList[indexPath.row]: ", dataList[indexPath.row])

        cell.delegate = self
        
        let row = dataList[indexPath.row]
        
        if row.complete {
            cell.checkBtn.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        } else {
            cell.checkBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        
        cell.titleLabel.text = row.title
        cell.memoLabel.text = row.memo
        cell.deadLineLabel.text = row.deadLineDate
        
        if let tag = row.tag {
            cell.tagLabel.text = "#\(tag)"
        }
//      이 부분을 넣어주면 셀의 데이터를 명확하게 지정해주니 셀이 재사용되어 뷰가 보여도, 정상적으로 잘 나타나는데
//      이 부분이 없으면 여기저기 셀에 개판도 이런 개판이 없다.
//      하지만, prepareForReuse 함수를 이용해 해결할 수 있었다.
//        else {
//            cell.tagLabel.text = nil
//        }
        
        if row.priority != 0 {
            cell.priorityLabel.text = "우선순위 : \(Priority.checkedPriority(segmentIndex: row.priority))"
        }
        
        if indexPath.row == dataList.count - 1 {
            cell.lineView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}

extension AllListViewController: checkBtnTappedDelegate {
    func cellCheckBtnTapped(cell: UITableViewCell) {
        // btn 을 눌렀을 때 감지한 셀의 indexPath 가져오기
        if let indexPath = mainView.tableView.indexPath(for: cell) {
            let item = dataList[indexPath.row]
            todoRepository.updateComplete(item)
            mainView.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
}
