//
//  ApiService+GithubFetured.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import Foundation

protocol GithubSearchApi: Actor {
    func fetchTrending(for period: String) async throws -> [Repository]
}

extension ApiService: GithubSearchApi {
    
    func fetchTrending(for period: String) async throws -> [Repository] {
        guard let reqest = ApiRequest
            .featured(period: period)
            .urlRequest else {
                throw ApiError.invalidUrl
        }
        let searchResponse: SearchResponse = try await perfomRequest(reqest)
        return searchResponse.items
    }
}
