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
        let apiReqeust = ApiRequest.featured(period: period)
        let searchResponse: SearchResponse = try await perfomRequest(apiReqeust)
        return searchResponse.items
    }
}
