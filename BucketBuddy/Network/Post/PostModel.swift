//
//  PostModel.swift
//  BucketBuddy
//
//  Created by eunseou on 4/23/24.
//

import Foundation


// MARK: - UploadImage
struct uploadIamgeQuery: Encodable {
    let files: Data
}

struct uploadIamgeModel: Decodable {
    let files: [String]
}

// MARK: - CreatePost
struct WritePostQuery: Encodable {
    let title: String
    let content: String
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let product_id: String
    let files: Array<String>?
}

struct WritePostModel: Decodable {
    let post_id: String
    let product_id: String
    let title: String
    let content: String
    let content1: String
    let content2: String
    let content3: String
    let content4: String
    let content5: String
    let createdAt: String
    let creater: JoinModel
    let files: Array<String>
    //let likes: Array<String>
   // let hashTags: Array<String>
  //  let coments: Array<String>
}

// MARK: - FetchPost
struct FetchPostQuery: Encodable {
    let next: String
    let limit: String
    let product_id: String
}

struct FetchPostModel: Decodable {
    let accessToken: String
    let refreshToken: String
}
