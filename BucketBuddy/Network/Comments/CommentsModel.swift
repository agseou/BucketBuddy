//
//  CommentsModel.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation
import Alamofire

// MARK: - UploadImage
struct CommentQuery: Encodable {
    let content: String
}

struct CommnentModel: Decodable {
    let commnet_id: String
    let content: String
    let createdAt: String
    let creator: JoinModel
}

