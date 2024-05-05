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

struct uploadImageModel: Decodable {
    let files: [String]
}

// MARK: - CreatePost
struct WritePostQuery: Encodable {
    let title: String
    let content: String
    let content1: String?
    let content2: String?
   // let content3: String?
   // let content4: String?
   // let content5: String?
    let product_id: String
    let files: Array<String>?
}

struct WritePostModel: Decodable {
    let post_id: String
    let product_id: String
    let title: String?
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let createdAt: String
    let creater: UserModel?
    let files: Array<String>
    //let likes: Array<String>
   // let hashTags: Array<String>
  //  let coments: Array<String>
}


struct CompleteToggleQuery: Encodable {
    let product_id: String
}

// MARK: - FetchPost
struct FetchPostQuery: Encodable {
    let next: String?
    let limit: String?
    let product_id: String?
    
    init(next: String?, limit: String?, product_id: String?) {
        self.next = next
        self.limit = limit
        self.product_id = product_id
    }
}

struct FetchPostModel: Decodable {
    let data: [PostModel]
    let next_cursor: String
}

struct PostModel: Decodable {
    let post_id: String
    let product_id: String?
    let title: String?
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let createdAt: String
    let creator: UserModel
    let files: [String]?
    let likes: [String]
    let hashTags: [String]
    let comments: [comment]
}

extension PostModel { static var defaultPostModel: PostModel { return PostModel(post_id: "", product_id: nil, title: nil, content: nil, content1: nil, content2: nil, content3: nil, content4: nil, content5: nil, createdAt: "", creator: UserModel.defaultUserModel, files: [], likes: [], hashTags: [], comments: []) }
}


struct comment: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: UserModel
}
