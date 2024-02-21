//
//  TodoListViewController.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/14/24.
//

import UIKit
import RealmSwift

final class TodoListViewController: BaseViewController {

    private let mainView = TodoListView()
    private var todoRepository = Repository()
    private var countDic: [TodoList: Int] = [:]
    private var listData: Results<ListModel>?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        
        self.navigationController?.isToolbarHidden = false
        
        configureToolBar()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        navigationController?.isToolbarHidden = false
        fetchTodoCountData()
        fetchListData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isToolbarHidden = true
    }
    
    @objc func didAddTodoBtnTapped() {
        let vc = TodoViewController()
        vc.selectMode = .create
        vc.todoDelegate = self
        transition(viewController: vc, style: .presentNavigation)
    }

    @objc func didAddListBtnTapped() {
        let vc = AddListViewController()
        vc.listDelegate = self
        transition(viewController: vc, style: .presentNavigation)
    }
    
}

extension TodoListViewController {
    
    private func configureToolBar() {
        mainView.addTodoBtn.addTarget(self, action: #selector(didAddTodoBtnTapped), for: .touchUpInside)
        
        let addTodoBtnItem = UIBarButtonItem(customView: mainView.addTodoBtn)
        let addListBtnItem = UIBarButtonItem(title: "목록 추가", style: .plain, target: self, action: #selector(didAddListBtnTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // 공백을 넣고싶을때마다 배열안에 넣어주어야 함
        // ex) content, space, content, space, content -> view, 공백, view, 공백, view 이런식으로 나옴
        self.toolbarItems = [addTodoBtnItem, flexibleSpace, addListBtnItem]
    }
    
    private func fetchTodoCountData() {
        countDic = todoRepository.fetchTodoListCount()
        mainView.collectionView.reloadData()
    }
    
    private func fetchListData() {
        listData = todoRepository.fetchTable()
        mainView.tableView.reloadData()
    }
    
}

// MARK: - CollectionView
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
        let vc = DetailTodoListViewController()
        vc.mainView.navTitle.text = TodoList.allCases[indexPath.row].rawValue
        transition(viewController: vc, style: .push)
    }
}

// MARK: - TableView
extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return mainView.createHeaderView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listData else { return 0 }
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        
        guard let listData else { return cell }
        
        let row = listData[indexPath.row]
        
        // View쪽은 View만 그리는 역할만 시켜주자
        cell.updateCell(title: row.title, count: row.todoList.count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK: - PassDelegate
extension TodoListViewController: PassTodoDelegate, PassListDelegate {
    
    func fetchTodoReceived() {
        fetchTodoCountData()
        fetchListReceived()
    }
    
    func fetchListReceived() {
        fetchTodoCountData()
        fetchListData()
    }
}
