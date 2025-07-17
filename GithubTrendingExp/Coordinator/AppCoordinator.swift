//
//  Coordinator.swift
//  GithubTrendingExp
//
//  Created by EVGENY SYSENKA on 15/07/2025.
//

import Foundation
import SwiftUI

// MARK: - Navigation Protocol
enum NavigationRoute: Hashable {
    case trendingList
    case repositoryDetail(repo: Repository)
}

protocol NavigationCoordinatorProtocol {
    func push(_ route: NavigationRoute)
    func pop(_ route: NavigationRoute)
}

// MARK: - Observable Coordinator
@Observable
final class AppCoordinator: NavigationCoordinatorProtocol {
    
    @ObservationIgnored
    let dependencies: AppDependencies
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    
    var path: [NavigationRoute] = []
    
    func push(_ route: NavigationRoute) {
        path.append(route)
    }
    
    func pop(_ route: NavigationRoute) {
        if let index = path.lastIndex(of: route) {
            path.removeSubrange(index..<path.endIndex)
        }
    }
}

// MARK: - Coordinator Root View
struct CoordinatorView<Content: View>: View {
    
    @Bindable var coordinator: AppCoordinator
    let content: () -> Content
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            scene(for: .trendingList)
                .navigationDestination(for: NavigationRoute.self) { route in
                    scene(for: route)
                }
                .environment(coordinator)
                
        }
        .modelContainer(for: [FavoriteItem.self])
    }
    
    @ViewBuilder
    func scene(for route: NavigationRoute) -> some View {
        switch route {
            case .trendingList:
                let viewModel = TrendingListViewModel(
                    apiService: coordinator.dependencies.apiSearchService,
                    favoriteStore: coordinator.dependencies.favoriteStore
                )
                TrendingListScreen(viewModel: viewModel)
                
            case .repositoryDetail(let repo):
                let viewModel = RepositoryDetailModel(
                    repository: repo,
                    apiService: coordinator.dependencies.apiRepoService
                )
                RepositoryDetailScreen(viewModel: viewModel)
                
        }
    }
}

