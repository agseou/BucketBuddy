//
//  String+Extension.swift
//  BucketBuddy
//
//  Created by eunseou on 4/30/24.
//

import Foundation

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)  // UTC
        return dateFormatter.date(from: self)
    }
    
    
    static func from(date: Date, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)  // UTC
        return dateFormatter.string(from: date)
    }
}
