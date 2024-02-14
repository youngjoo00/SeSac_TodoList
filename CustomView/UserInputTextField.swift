//
//  UserInputTextField.swift
//  SeSac_Media
//
//  Created by youngjoo on 2/8/24.
//

import UIKit

class UserInputTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        addLeftPadding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
