//
//  TagViewController.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/15/24.
//

import UIKit

final class TagViewController: BaseViewController {
    
    let mainView = TagView()
    
    var section = 0
    var tag = ""
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        mainView.textField.text = tag
    }
    
    @objc func didRightBarButtonItemTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("postTag"), object: nil, userInfo: ["tag": mainView.textField.text!, "section": section])
        navigationController?.popViewController(animated: true)
    }
}

extension TagViewController {
    
    func configureNavigationBar() {
        let rightBtnItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(didRightBarButtonItemTapped))
        rightBtnItem.tintColor = .systemGray5
        
        navigationItem.rightBarButtonItem = rightBtnItem
        
        navigationItem.titleView = mainView.navTitle
    }
}
