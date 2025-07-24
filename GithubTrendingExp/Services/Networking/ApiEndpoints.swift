//
//  ApiEndpoints.swift
//  GithubTrendingExp
//
//  Created by EVGENY SYSENKA on 15/07/2025.
//

import Foundation


// MARK: - Base reqeust protocol.

protocol ApiEndpointType {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: String { get }
    var headers: [String: String] { get }
    var baseURL: String { get }
    
    var urlRequest: URLRequest? { get }
}

extension ApiEndpointType {
    var urlRequest: URLRequest? {
        
        guard var components = URLComponents(string: baseURL + path) else { return nil }
        components.queryItems = queryItems
        
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}

enum ApiRequest {
    case featured(period: String)
    case languages(owner: String, repo: String)
    
    case readme(owner: String, repo: String)
}

extension ApiRequest: ApiEndpointType {
    
    var baseURL: String { "https://api.github.com" }
    
    var method: String {
        switch self {
            default:
              return "Get"
        }
    }
    
    var path: String {
        switch self {
            case .featured:
                return "/search/repositories"
                
            case .readme(let owner, let repo):
                return "/repos/\(owner)/\(repo)/readme"
                
            case .languages(let owner, let repo):
                return "/repos/\(owner)/\(repo)/languages"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
            case .featured(let period):
                return [
                    URLQueryItem(name: "q", value: "created:>\(period)"),
                    URLQueryItem(name: "sort", value: "stars"),
                    URLQueryItem(name: "order", value: "desc")
                ]
            case .readme, .languages:
                return nil
        }
    }
    
    var headers: [String: String] {
        switch self {
            default:
                return [
                    "Accept": "application/vnd.github+json"
                ]
        }
    }
}
