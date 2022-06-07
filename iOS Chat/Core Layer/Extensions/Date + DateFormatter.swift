//
//  DateManger.swift
//  iOS Chat
//
//  Created by Macbook on 10.03.2022.
//

import Foundation

extension Date {
    
    static func stringFromDate(date: Date) -> String {
        
        let currentCalendar = Calendar.current
        
        if currentCalendar.isDateInToday(date) {
            let formatter = DateFormatter.customFormatter(with: "HH:mm")
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter.customFormatter(with: "dd/MM")
            return formatter.string(from: date)
        }
    }
}

extension DateFormatter {
    
    static func customFormatter(with format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = .current
        return formatter
    }
}
