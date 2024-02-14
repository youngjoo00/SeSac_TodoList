//
//  WhiteTextLabel.swift
//  SeSac_Media
//
//  Created by youngjoo on 1/30/24.
//

import UIKit

class WhiteTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WhiteTitleLabel {
    func configureView() {
        textColor = .white
        font = .boldSystemFont(ofSize: 20)
    }
}
