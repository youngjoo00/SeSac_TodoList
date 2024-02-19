//
//  DateViewController.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/15/24.
//

import UIKit

final class DateViewController: BaseViewController {
    
    let mainView = DateView()
    
    var dateSpace: ((Date) -> Void)?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    }
    
    @objc func didRightBarButtonItemTapped() {
        
        dateSpace?(mainView.datePickerView.date)
        navigationController?.popViewController(animated: true)
    }
    
}

extension DateViewController {
    
    func configureNavigationBar() {
        let rightBtnItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(didRightBarButtonItemTapped))
        rightBtnItem.tintColor = .systemGray5
        
        navigationItem.rightBarButtonItem = rightBtnItem
        
        navigationItem.titleView = mainView.navTitle
    }
}
