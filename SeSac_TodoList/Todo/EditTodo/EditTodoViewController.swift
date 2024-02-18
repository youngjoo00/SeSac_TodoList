//
//  EditTodoViewController.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/18/24.
//

import UIKit
import RealmSwift

final class EditTodoViewController: BaseViewController {
    
    let mainView = AddTodoView()
    let todoRepository = TodoTableRepository()
    
    // 받아올 데이터
    var todoData: TodoModel!
    
    var textField: String?
    var textView: String?
    var priority: Int = 0
    var deadLineDate: Date?
    
    var todoDelegate: PassTodoDelegate?

    var subTitleDic: [Int: String] = [:] {
        didSet {
            self.mainView.tableView.reloadData()
        }
    }
    
    var isMemoEdited = false
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        configureNavigationBar()
        
        subTitleDic = Todo.returnStringList(todoData)
        textField = todoData.title
        textView = todoData.memo
        priority = todoData.priority
        deadLineDate = todoData.deadLineDate
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    @objc func didLeftBarButtonItemTapped() {
        dismiss(animated: true)
    }
    
    @objc func didRightBarButtonItemTapped() {

        guard let title = textField, let deadLineDate = deadLineDate else {
            showToast(message: "제목, 마감일은 꼭 입력해주세요")
            return
        }

        todoRepository.updateItem(todoData, title: title, memo: textView ?? "", deadLineDate: deadLineDate, tag: subTitleDic[3], priority: priority)
        
        todoDelegate?.fetchTodoReceived()
        dismiss(animated: true)
    }
    
    @objc func tagNotification(notification: NSNotification) {
        guard let section = notification.userInfo?["section"] as? Int else { return }
        guard let tag = notification.userInfo?["tag"] as? String else { return }
        
        subTitleDic[section + 1] = tag
    }
    
    @objc func didChangeValueTextField(_ textField: UITextField, indexPath: IndexPath) {
        self.textField = textField.text!
    }
}

extension EditTodoViewController {
    
    func configureNavigationBar() {
        let leftBtnItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didLeftBarButtonItemTapped))
        leftBtnItem.tintColor = .systemBlue
        let rightBtnItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(didRightBarButtonItemTapped))
        rightBtnItem.tintColor = .systemGray5
        
        navigationItem.leftBarButtonItem = leftBtnItem
        navigationItem.rightBarButtonItem = rightBtnItem
        
        navigationItem.titleView = mainView.navTitle
    }
}

extension EditTodoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DetailTodoList.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleMemoTableViewCell.identifier, for: indexPath) as! TitleMemoTableViewCell
            
            cell.titleTextField.addTarget(self, action: #selector(didChangeValueTextField), for: .editingChanged)
            cell.titleTextField.text = subTitleDic[0]
            
            cell.memoTextView.delegate = self
            cell.memoTextView.text = subTitleDic[1]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SubTodoTableViewCell.identifier, for: indexPath) as! SubTodoTableViewCell
            
            cell.titleLabel.text = DetailTodoList.allCases[indexPath.section].rawValue
            cell.subTitleLabel.text = subTitleDic[indexPath.section + 1]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 1 {
            let vc = DetailTodoList.allCases[indexPath.section].viewController as! DateViewController
            vc.dateSpace = { date in
                self.subTitleDic[indexPath.section + 1] = CustomDateFormatter.shared.formatDateString(date: date)
                self.deadLineDate = date
            }
            transition(viewController: vc, style: .push)
            
        } else if indexPath.section == 2 {
            let vc = DetailTodoList.allCases[indexPath.section].viewController as! TagViewController
            vc.section = indexPath.section
            vc.tag = subTitleDic[3] ?? ""
            NotificationCenter.default.addObserver(self, selector: #selector(tagNotification), name: NSNotification.Name("postTag"), object: nil)
            transition(viewController: vc, style: .push)
            
        } else if indexPath.section == 3 {
            let vc = DetailTodoList.allCases[indexPath.section].viewController as! PriorityViewController
            vc.segmentIndex = priority
            vc.section = indexPath.section
            vc.delegate = self
            transition(viewController: vc, style: .push)
        }
    }
}

extension EditTodoViewController: PassDataDelegate {
    
    func priorityReceived(segmentIndex priority: Int, section: Int) {
        self.priority = priority
        let priorityString = Priority.checkedPriority(segmentIndex: priority)
        self.subTitleDic[section + 1] = priorityString
    }
    
}

extension EditTodoViewController: UITextViewDelegate {
    
    // 편집을 시작했을 때
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "메모" && textView.textColor == .systemGray5 && !isMemoEdited {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    // 편집이 끝났을 때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메모"
            textView.textColor = .systemGray5
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.textColor == .white {
            self.textView = textView.text
            isMemoEdited = true
        }
    }
}
