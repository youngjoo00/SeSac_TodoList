//
//  LineView.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/17/24.
//

import UIKit

class LineView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LineView {
    
    func configureView() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray2.cgColor
    }
}
