//
//  HandleError.swift
//  BucketBuddy
//
//  Created by eunseou on 4/18/24.
//

import Foundation
import Alamofire

/*
 [💡Error 핸들 방법]
 handleCommonErrors: 공통 에러코드를 다룸 👾
 - 공통 StatusCode에 걸리면 true
 - false를 반환하면 각각의 오류코드를 조회하도록!
 */

func handleCommonErrors(_ statusCode: Int) -> Bool {
    switch statusCode {
    case 420: print("👾 Header 값을 확인하세요.")
    case 429: print("👾 과호출입니다.")
    case 444: print("👾 비정상 URL입니다.")
    case 500: print("👾 ServerError")
    default:
        return false
    }
    return true
}

func handleLoginStatusError(_ statusCode: Int) {
    switch statusCode {
    case 400: print("👾 필수값을 채워주세요")
    case 401: print("👾 계정을 확인해주세요!")
    default: print("status code: \(statusCode)")
    }
}
