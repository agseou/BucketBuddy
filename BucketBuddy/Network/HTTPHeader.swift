//
//  HTTPHeader.swift
//  BucketBuddy
//
//  Created by eunseou on 4/14/24.
//

import Foundation

enum HTTPHeader: String {
    
    case authorization = "Authorization"
    case secretKey = "SesacKey"
    case refresh = "Refresh"
    case contentType = "Content-Type"
    case json = "application/json"
    case multifart = "multipart/form-data"
    
}
