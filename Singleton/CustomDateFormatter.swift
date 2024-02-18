//
//  DateFormatter.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/17/24.
//

import Foundation
import Then

final class CustomDateFormatter {
    
    static let shared = CustomDateFormatter()
    
    private init() { }
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
        $0.locale = Locale(identifier: "ko_KR")
    }

    func todayDate() -> Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return today
    }
    
    func formatDateString(date: Date) -> String {
        return dateFormatter.string(from: date)
    }

}
