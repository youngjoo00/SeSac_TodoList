//
//  DateFormatter.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/17/24.
//

import Foundation

enum CustomDateFormatter {
    
    static func todayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter.string(from: Date())
    }
}
