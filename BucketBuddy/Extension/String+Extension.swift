//
//  String+Extension.swift
//  BucketBuddy
//
//  Created by eunseou on 4/30/24.
//

import Foundation

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss'Z'") -> Date? { // 포맷 변경
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            return dateFormatter.date(from: self)
        }
    
    
    static func from(date: Date, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) 
        return dateFormatter.string(from: date)
    }
    
    func Ddays() -> String {
            guard let eventDate = self.toDate() else { return "기한 없음" }
            
            let currentDate = Date()
            let calendar = Calendar.current
            let startOfDayEvent = calendar.startOfDay(for: eventDate)
            let startOfDayCurrent = calendar.startOfDay(for: currentDate)

            let components = calendar.dateComponents([.day], from: startOfDayCurrent, to: startOfDayEvent)
            if let days = components.day {
                if days > 0 {
                    return "D-\(days)" // 미래 일자
                } else if days < 0 {
                    return "D+\(-days)" // 과거 일자
                } else {
                    return "D-Day" // 오늘
                }
            }
            return "Date Calculation Error"
        }
}
