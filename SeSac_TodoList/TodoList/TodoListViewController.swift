//
//  TodoListViewController.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/14/24.
//

import UIKit
import RealmSwift

final class TodoListViewController: BaseViewController {

    enum TodoList: String, CaseIterable {
        case today = "오늘"
        case expected = "예정"
        case all = "전체"
        case flagSign = "깃발 표시"
        case complete = "완료됨"
        
        var image: UIImage? {
            switch self {
            case .today:
                return UIImage(systemName: "calendar")
            case .expected:
                return UIImage(systemName: "calendar.badge.exclamationmark")
            case .all:
                return UIImage(systemName: "apple.logo")
            case .flagSign:
                return UIImage(systemName: "flag.fill")
            case .complete:
                return UIImage(systemName: "checkmark")
            }
        }
        
        var viewController: UIViewController {
            switch self {
            case .today:
                return ViewController()
            case .expected:
                return ViewController()
            case .all:
                return AllListViewController()
            case .flagSign:
                return ViewController()
            case .complete:
                return ViewController()
            }
            
        }
    }
    
    let mainView = TodoListView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        
        self.navigationController?.isToolbarHidden = false
        
        configureToolBar()
        
    }
    
    @objc func leftButtonTapped() {
        transition(viewController: AddTodoViewController(), style: .presentNavigation)
    }

    @objc func rightButtonTapped() {
        print(#function)
    }
}

extension TodoListViewController {
    
    func configureToolBar() {
        mainView.addTodoBtn.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        
        let addTodoBtnItem = UIBarButtonItem(customView: mainView.addTodoBtn)
        let addListBtnItem = UIBarButtonItem(title: "목록 추가", style: .plain, target: self, action: #selector(rightButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // 공백을 넣고싶을때마다 배열안에 넣어주어야 함
        // ex) content, space, content, space, content -> view, 공백, view, 공백, view 이런식으로 나옴
        self.toolbarItems = [addTodoBtnItem, flexibleSpace, addListBtnItem]
    }
    
}

extension TodoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TodoList.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoListCollectionViewCell.identifier, for: indexPath) as! TodoListCollectionViewCell
        
        let row = TodoList.allCases[indexPath.item]
        cell.mainImageView.image = row.image
        cell.countLabel.text = "0"
        cell.titleLabel.text = row.rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TodoList.allCases[indexPath.row].viewController
        transition(viewController: vc, style: .push)
    }
}
