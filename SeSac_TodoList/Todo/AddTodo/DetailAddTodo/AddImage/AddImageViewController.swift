//
//  AddImageViewController.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/15/24.
//

import UIKit

final class AddImageViewController: BaseViewController {
    
    let mainView = AddImageView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = mainView.navTitle
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    }
    
    @objc func didRightBarButtonItemTapped() {
        print(#function)
    }
    
}

extension AddImageViewController {
    
    func configureNavigationBar() {
        let rightBtnItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(didRightBarButtonItemTapped))
        rightBtnItem.tintColor = .systemGray5
        
        navigationItem.rightBarButtonItem = rightBtnItem
        
        navigationItem.titleView = mainView.navTitle
    }
}
