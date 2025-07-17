//
//  GithubTrendingExpApp.swift
//  GithubTrendingExp
//
//  Created by EVGENY SYSENKA on 15/07/2025.
//

import SwiftUI
import SwiftData

@main
struct GithubTrendingExpApp: App {
    private let coordinator: AppCoordinator
    
    private let dependencies = AppDependencies(
        apiSearchService: ApiService(),
        apiRepoService: ApiService(),
        favoriteStore: FavoriteStore()
    )

    init() {
        self.coordinator = AppCoordinator(dependencies: dependencies)
    }

    var body: some Scene {
        WindowGroup {
            CoordinatorView(coordinator: coordinator) {
                EmptyView()
            }
            .environment(coordinator)
        }
    }
}
