//
//  ApiService+GithubRepoApi.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 07/06/2025.
//

import Foundation

protocol GithubRepoApi: Actor {
    func fetchLanguages(owner: String, repo: String) async throws -> [Language]
}

extension ApiService: GithubRepoApi {
    
    func fetchLanguages(owner: String, repo: String) async throws -> [Language] {
        guard let request = ApiRequest
            .languages(owner: owner, repo: repo)
            .urlRequest else {
                throw ApiError.custom(message: "Invalid request.")
        }
        let jsonLanguages: JsonLanguage = try await perfomRequest(request)
        let languages = jsonLanguages.map { Language(name: $0.key, value: $0.value) }
        
        return languages
    }
}
