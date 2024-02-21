//
//  AddTodoViewController.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/14/24.
//

import UIKit
import RealmSwift

final class TodoViewController: BaseViewController {
    
    let mainView = TodoView()
    let todoRepository = Repository()
    
    // 받아올 데이터
    var todoData: TodoModel!
    var selectMode: SelectMode?
    
    var textField: String?
    var textView: String?
    var deadLineDate: Date?
    var priority: Int = 0
    var image: UIImage?
    var list: ListModel?
    
    var todoDelegate: PassTodoDelegate?
    
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
        
        view.backgroundColor = .darkGrayBackgroundColor
        
        configureNavigationBar()
        checkMode()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    @objc func didLeftBarButtonItemTapped() {
        dismiss(animated: true)
    }
    
    @objc func didRightBarButtonItemTapped() {
        
        guard let title = textField, let deadLineDate = deadLineDate, let list = list,
              (!title.isEmpty && !DateManager.shared.formatDateString(date: deadLineDate).isEmpty && !list.title.isEmpty) else {
            showToast(message: "제목, 마감일, 목록은 꼭 입력해주세요")
            return
        }
        
        guard let selectMode else { return }
        
        switch selectMode {
        case .create:
            createData()
        case .update:
            updateData()
        }
        
        func createData() {
            let data = TodoModel(title: title,
                                 memo: textView ?? "",
                                 regDate: Date(),
                                 deadLineDate: deadLineDate,
                                 tag: subTitleDic[3],
                                 priority: priority,
                                 complete: false)
            todoRepository.createTodoList(list: list, todo: data)
            
            if let image = image {
                saveImageToDocument(image: image, filename: "\(data.id)")
            }
        }
        
        func updateData() {
            todoRepository.updateItem(todoData,
                                      title: title,
                                      memo: textView ?? "",
                                      deadLineDate: deadLineDate,
                                      tag: subTitleDic[3],
                                      priority: priority)
            
            if let image = image {
                saveImageToDocument(image: image, filename: "\(todoData.id)")
            }
        }
        
        //        todoRepository.createItem(item: data)
        
        todoDelegate?.fetchTodoReceived()
        
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

extension TodoViewController {
    
    func configureNavigationBar() {
        let leftBtnItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didLeftBarButtonItemTapped))
        leftBtnItem.tintColor = .systemBlue
        let rightBtnItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(didRightBarButtonItemTapped))
        rightBtnItem.tintColor = .systemGray5
        
        navigationItem.leftBarButtonItem = leftBtnItem
        navigationItem.rightBarButtonItem = rightBtnItem
        
        navigationItem.titleView = mainView.navTitle
    }
    
    func checkMode() {
        guard let mode = selectMode else { return }
        
        switch mode {
        case .create:
            textView = "메모"
        case .update:
            subTitleDic = Todo.returnStringList(todoData: todoData)
            textField = todoData.title
            textView = todoData.memo?.isEmpty == true ? "메모" : todoData.memo
            deadLineDate = todoData.deadLineDate
            priority = todoData.priority
            image = loadImageToDocument(filename: "\(todoData.id)")
            list = todoData.superTable.first
        }
    }
}

extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            cell.titleTextField.text = textField
            
            cell.memoTextView.delegate = self
            cell.memoTextView.text = textView
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SubTodoTableViewCell.identifier, for: indexPath) as! SubTodoTableViewCell
            
            let section = DetailTodoList.allCases[indexPath.section].rawValue
            cell.titleLabel.text = section
            
            if section == "이미지 추가" {
                cell.photoImageView.image = image
            } else {
                cell.subTitleLabel.text = subTitleDic[indexPath.section + 1]
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let vc = DetailTodoList.allCases[indexPath.section].viewController as! DateViewController
            vc.dateSpace = { date in
                self.subTitleDic[indexPath.section + 1] = DateManager.shared.formatDateString(date: date)
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
        } else if indexPath.section == 4 {
            let vc = UIImagePickerController()
            vc.delegate = self
            
            transition(viewController: vc, style: .present)
        } else if indexPath.section == 5 {
            let vc = DetailTodoList.allCases[indexPath.section].viewController as! ListViewContorller
            vc.section = indexPath.section
            vc.delegate = self
            transition(viewController: vc, style: .push)
        }
    }
}


extension TodoViewController: PassDataDelegate, PassListStringDelegate {
    
    func priorityReceived(segmentIndex priority: Int, section: Int) {
        self.priority = priority
        let priorityString = Priority.checkedPriority(segmentIndex: priority)
        self.subTitleDic[section + 1] = priorityString
    }
    
    func listReceived(list: ListModel, section: Int) {
        self.list = list
        self.subTitleDic[section + 1] = list.title
    }
}

extension TodoViewController: UITextViewDelegate {
    
    // 편집을 시작했을 때
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "메모" && self.textView == "메모" {
            textView.text = nil
        }
        textView.textColor = .white
    }
    
    // 편집이 끝났을 때
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

extension TodoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = pickedImage
            
            mainView.tableView.reloadData()
        }
        
        dismiss(animated: true)
    }
}
