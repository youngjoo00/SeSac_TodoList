//
//  AddTodoViewController.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/14/24.
//

import UIKit

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
        print(#function)
    }
    
    @objc func tagNotification(notification: NSNotification) {
        guard let section = notification.userInfo?["section"] as? Int else { return }
        guard let tag = notification.userInfo?["tag"] as? String else { return }
        
        subTitleDic[section] = tag
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
            vc.section = indexPath.section
            vc.delegate = self
            transition(viewController: vc, style: .push)
        }
    }
}

extension AddTodoViewController: PassDataDelegate {
    
    func priorityReceived(segmentIndex: Int, section: Int) {
        subTitleDic[section] = "\(segmentIndex)"
    }
    
}
