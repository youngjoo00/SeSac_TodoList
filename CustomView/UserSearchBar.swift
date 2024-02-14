//
//  UserSearchBar.swift
//  SeSac_Media
//
//  Created by youngjoo on 2/9/24.
//

import UIKit

class UserSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UserSearchBar {
    
    func configureView() {
        searchBarStyle = .minimal
        searchTextField.backgroundColor = .systemGray4
    }
}
