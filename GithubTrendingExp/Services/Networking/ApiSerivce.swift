//
//  ApiSerive.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import SwiftUI
import UIKit

typealias JSONDictionary = [String: Any]

enum ApiError: Error, Equatable {
    case invalidUrl
    case invalidResponse
    case invalidStatusCode(code: Int)
    
    case custom(message: String)
}

actor ApiService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func perfomRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse, data.count > 0 else {
            throw ApiError.invalidResponse
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw ApiError.invalidStatusCode(code: response.statusCode)
        }
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            throw error
        }
    }
    
    func perfomDataRequest(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse, data.count > 0 else {
            throw ApiError.invalidResponse
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw ApiError.invalidStatusCode(code: response.statusCode)
        }
        
        guard data.count >= 0 else {
            throw ApiError.custom(message: "Invalid data response.")
        }
        return data
    }
}


