//
//  AddListViewController.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/20/24.
//

import UIKit

final class AddListViewController: BaseViewController {
    
    let mainView = AddListView()
    
    let repository = Repository()
    
    var listDelegate: PassListDelegate?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        navigationItem.titleView = mainView.navTitle
        
        view.backgroundColor = .darkGrayBackgroundColor
    }
    
    func configureNavigationBar() {
        
        navigationItem.titleView = mainView.navTitle
        
        let leftBtnItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didLeftBarButtonItemTapped))
        leftBtnItem.tintColor = .systemBlue
        
        let rightBtnItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didRightBarButtonItemTapped))
        rightBtnItem.tintColor = .systemGray5
        
        navigationItem.leftBarButtonItem = leftBtnItem
        navigationItem.rightBarButtonItem = rightBtnItem

    }
    
    @objc func didLeftBarButtonItemTapped() {
        dismiss(animated: true)
    }
    
    @objc func didRightBarButtonItemTapped() {
        
        guard let title = mainView.listTextField.text, !title.isEmpty else {
            showToast(message: "목록 이름을 작성해주세요!")
            return
        }
        let data = ListModel(title: mainView.listTextField.text!, regDate: Date())
        
        repository.createItem(item: data)
        
        listDelegate?.fetchListReceived()
        dismiss(animated: true)
    }
    
}
