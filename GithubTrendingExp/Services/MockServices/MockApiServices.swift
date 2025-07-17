//
//  MockSearchApi.swift
//  GithubTrendingExpTests
//
//  Created by EVGENY SYSENKA on 17/07/2025.
//

import Foundation

actor MockGithubSearchApi: GithubSearchApi {
    private var repositories: [Repository] = []
    
    func set(repositories: [Repository]) {
        self.repositories = repositories
    }
    
    func fetchTrending(for period: String) async throws -> [Repository] {
        return repositories
    }
}

actor MockGithubRepoApi: GithubRepoApi {    
    private var languages: [Language] = []
    
    func set(languages: [Language]) {
        self.languages = languages
    }
    
    func fetchLanguages(owner: String, repo: String) async throws -> [Language] {
        languages
    }
}
