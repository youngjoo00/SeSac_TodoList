//
//  AddTodoViewController.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/14/24.
//

import UIKit
import RealmSwift

protocol PassDataDelegate {
    func priorityReceived(segmentIndex: Int, section: Int)
}

final class AddTodoViewController: BaseViewController {
    
    enum DetailTodoList: String, CaseIterable {
        case title
        case date = "마감일"
        case tag = "태그"
        case priority = "우선 순위"
        case addImage = "이미지 추가"
        
        var viewController: UIViewController {
            switch self {
            case .title:
                return ViewController()
            case .date:
                return DateViewController()
            case .tag:
                return TagViewController()
            case .priority:
                return PriorityViewController()
            case .addImage:
                return AddImageViewController()
            }
        }
        
    }
    
    let mainView = AddTodoView()
    var textField: String?
    var textView: String?
    var segmentIndex: Int?
    
    var subTitleDic: [Int: String] = [:] {
        didSet {
            self.mainView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        configureNavigationBar()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    @objc func didLeftBarButtonItemTapped() {
        dismiss(animated: true)
    }
    
    @objc func didRightBarButtonItemTapped() {
        guard let title = textField, let memo = textView, let deadLineDate = subTitleDic[1], let priority = segmentIndex else {
            showToast(message: "제목, 메모, 마감일, 우선순위는 꼭 입력해주세요")
            return
        }
        
        let data = TodoModel(title: title, memo: memo, regDate: Date(), deadLineDate: deadLineDate, tag: subTitleDic[2], priority: priority, complete: false)
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(data)
            print(realm.configuration.fileURL ?? "")
        }
        
        dismiss(animated: true)
    }
    
    @objc func tagNotification(notification: NSNotification) {
        guard let section = notification.userInfo?["section"] as? Int else { return }
        guard let tag = notification.userInfo?["tag"] as? String else { return }
        
        subTitleDic[section] = tag
    }
    
    @objc func didChangeValueTextField(_ textField: UITextField, indexPath: IndexPath) {
        self.textField = textField.text!
    }
}

extension AddTodoViewController {
    
    func configureNavigationBar() {
        let leftBtnItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didLeftBarButtonItemTapped))
        leftBtnItem.tintColor = .systemBlue
        let rightBtnItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(didRightBarButtonItemTapped))
        rightBtnItem.tintColor = .systemGray5
        
        navigationItem.leftBarButtonItem = leftBtnItem
        navigationItem.rightBarButtonItem = rightBtnItem
        
        navigationItem.titleView = mainView.navTitle
    }
}

extension AddTodoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DetailTodoList.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddTodoTableViewCell.identifier, for: indexPath) as! AddTodoTableViewCell
            
            cell.titleTextField.addTarget(self, action: #selector(didChangeValueTextField), for: .editingChanged)
            cell.memoTextView.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SubAddTodoTableViewCell.identifier, for: indexPath) as! SubAddTodoTableViewCell
            
            cell.titleLabel.text = DetailTodoList.allCases[indexPath.section].rawValue
            cell.subTitleLabel.text = subTitleDic[indexPath.section]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 1 {
            let vc = DetailTodoList.allCases[indexPath.section].viewController as! DateViewController
            vc.dateSpace = { date in
                self.subTitleDic[indexPath.section] = date
            }
            transition(viewController: vc, style: .push)
            
        } else if indexPath.section == 2 {
            let vc = DetailTodoList.allCases[indexPath.section].viewController as! TagViewController
            vc.section = indexPath.section
            NotificationCenter.default.addObserver(self, selector: #selector(tagNotification), name: NSNotification.Name("postTag"), object: nil)
            transition(viewController: vc, style: .push)
            
        } else if indexPath.section == 3 {
            let vc = DetailTodoList.allCases[indexPath.section].viewController as! PriorityViewController
            vc.segmentIndex = segmentIndex
            vc.section = indexPath.section
            vc.delegate = self
            transition(viewController: vc, style: .push)
        }
    }
}

extension AddTodoViewController: PassDataDelegate {
    
    func priorityReceived(segmentIndex: Int, section: Int) {
        self.segmentIndex = segmentIndex
        let priorityString = Priority.checkedPriority(segmentIndex: segmentIndex)
        self.subTitleDic[section] = priorityString
    }
    
}


extension AddTodoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray5 {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메모"
            textView.textColor = .systemGray5
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.textView = textView.text
    }
}
