//
//  DateFormatter+Extension.swift
//  BucketBuddy
//
//  Created by eunseou on 4/30/24.
//

import Foundation

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        return formatter
    }()

    
    static func date(fromIso8601 string: String) -> Date? {
        return DateFormatter.iso8601Full.date(from: string)
    }

    
    static func string(fromIso8601 date: Date) -> String {
        return DateFormatter.iso8601Full.string(from: date)
    }
}
