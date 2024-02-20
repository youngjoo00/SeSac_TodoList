//
//  ListViewContorller.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/21/24.
//

import UIKit
import RealmSwift

final class ListViewContorller: BaseViewController {
    
    let mainView = ListView()
    
    let repository = Repository()
    
    var listData: Results<ListModel>?
    var section = 0
    var delegate: PassListStringDelegate?
    
    var selectIndex = 0
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = mainView.navTitle
        view.backgroundColor = .darkGrayBackgroundColor
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        fetchListData()
        updateTitleLabel()
        configureNavigationBar()
    }
    
    func fetchListData() {
        listData = repository.fetchTable()
        
        mainView.tableView.reloadData()
    }
    
    @objc func didRightBarButtonItemTapped() {
        
        guard let listData else { return }
        delegate?.listReceived(list: listData[selectIndex], section: section)
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension ListViewContorller {
    
    func configureNavigationBar() {
        let rightBtnItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(didRightBarButtonItemTapped))
        rightBtnItem.tintColor = .systemGray5
        
        navigationItem.rightBarButtonItem = rightBtnItem
        
        navigationItem.titleView = mainView.navTitle
    }
    
    func updateTitleLabel() {
        guard let listData else { return }
        mainView.titleLabel.text = listData[selectIndex].title + "에 생성됩니다."
    }
}

extension ListViewContorller: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listData else { return 0 }
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell")!
        
        guard let listData else { return cell }
        
        let row = listData[indexPath.row]
        cell.textLabel?.text = row.title
        cell.textLabel?.textColor = .white
        
        if selectIndex == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.imageView?.image = UIImage(systemName: "list.bullet.circle.fill")
        cell.imageView?.tintColor = .white
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        updateTitleLabel()
        tableView.reloadData()
    }

}
