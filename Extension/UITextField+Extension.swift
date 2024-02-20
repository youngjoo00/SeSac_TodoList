//
//  UITextField+Extension.swift
//  SeSac_Media
//
//  Created by youngjoo on 2/8/24.
//

import UIKit

extension UITextField {
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        // 텍스트필드의 leftView 를 항상 보이게 함으로써 10의 공백을 띄워줌
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func configureView() {
        textColor = .white
        autocorrectionType = .no
        spellCheckingType = .no
    }
    
    func setPlaceholder(placeholder: String, color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: color])
    }
}
