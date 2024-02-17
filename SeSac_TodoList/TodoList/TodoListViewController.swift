//
//  TodoListViewController.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/14/24.
//

import UIKit

protocol PassTodoDelegate {
    func fetchTodoReceived()
}

final class TodoListViewController: BaseViewController {

    let mainView = TodoListView()
    var todoRepository = TodoTableRepository()
    var countDic: [TodoList: Int] = [:]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        
        self.navigationController?.isToolbarHidden = false
        
        configureToolBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(todoModelCountNotification), name: NSNotification.Name("postTodoModelCount"), object: nil)
    }
    
    @objc func todoModelCountNotification(notification: NSNotification) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        navigationController?.isToolbarHidden = false
        fetchTodoCountData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isToolbarHidden = true
    }
    
    @objc func didAddTodoBtnTapped() {
        let vc = AddTodoViewController()
        vc.todoDelegate = self
        transition(viewController: vc, style: .presentNavigation)
    }

    @objc func didAddListBtnTapped() {
        print(#function)
    }
    
}

extension TodoListViewController {
    
    func configureToolBar() {
        mainView.addTodoBtn.addTarget(self, action: #selector(didAddTodoBtnTapped), for: .touchUpInside)
        
        let addTodoBtnItem = UIBarButtonItem(customView: mainView.addTodoBtn)
        let addListBtnItem = UIBarButtonItem(title: "목록 추가", style: .plain, target: self, action: #selector(didAddListBtnTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // 공백을 넣고싶을때마다 배열안에 넣어주어야 함
        // ex) content, space, content, space, content -> view, 공백, view, 공백, view 이런식으로 나옴
        self.toolbarItems = [addTodoBtnItem, flexibleSpace, addListBtnItem]
    }
    
    func fetchTodoCountData() {
        
        countDic = todoRepository.fetchTodoListCount()
        print(countDic)
        mainView.collectionView.reloadData()
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

        let count = countDic[row] ?? 0
        cell.countLabel.text = "\(count)"
        
        cell.titleLabel.text = row.rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TodoList.allCases[indexPath.row].viewController
        transition(viewController: vc, style: .push)
    }
}

extension TodoListViewController: PassTodoDelegate {
    func fetchTodoReceived() {
        fetchTodoCountData()
    }
}
