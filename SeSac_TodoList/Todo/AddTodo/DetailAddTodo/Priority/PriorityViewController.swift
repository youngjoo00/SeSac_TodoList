//
//  PriorityViewController.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/15/24.
//

import UIKit

final class PriorityViewController: BaseViewController {
    
    let mainView = PriorityView()
    
    var delegate: PassDataDelegate?
    var section = 0
    var segmentIndex: Int?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)

        checkedSegmentControl()
    }
    
    @objc func didRightBarButtonItemTapped() {
        
        delegate?.priorityReceived(segmentIndex: mainView.segmentControl.selectedSegmentIndex, section: section)
        navigationController?.popViewController(animated: true)
    }
    
}

extension PriorityViewController {
    
    func checkedSegmentControl() {
        if let segmentIndex {
            mainView.segmentControl.selectedSegmentIndex = segmentIndex
        } else {
            mainView.segmentControl.selectedSegmentIndex = 0
        }
    }
    
    func configureNavigationBar() {
        let rightBtnItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(didRightBarButtonItemTapped))
        rightBtnItem.tintColor = .systemGray5
        
        navigationItem.rightBarButtonItem = rightBtnItem
        
        navigationItem.titleView = mainView.navTitle
    }

}
