//
//  TargetType.swift
//  BucketBuddy
//
//  Created by eunseou on 4/11/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get } // get, post…
    var path: String { get }
    var header: [String: String] { get }
    var parameters: String? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension TargetType {
    
    func asURLRequest() throws -> URLRequest {
        let baseURL = try baseURL.asURL()
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        guard let finalURL = components?.url else { throw URLError(.badURL) }
        var urlRequest = try URLRequest(url: finalURL, method: method)
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpBody = parameters?.data(using: .utf8)
        if method != .get {
            urlRequest.httpBody = body
        }
        return urlRequest
    }
    
}
