//
//  AppDependencies.swift
//  GithubTrendingExp
//
//  Created by EVGENY SYSENKA on 17/07/2025.
//

import Foundation

typealias FavoritesStoreClosure = () -> FavoriteStore

struct AppDependencies {
    let apiSearchService: GithubSearchApi
    let apiRepoService: GithubRepoApi
    let favoriteStore: FavoriteStoreType
}

extension AppDependencies {
    
    @MainActor
    static var preview: AppDependencies {
        AppDependencies(
            apiSearchService: MockGithubSearchApi(),
            apiRepoService: MockGithubRepoApi(),
            favoriteStore: MockFavoriteStore()
        )
    }
}
