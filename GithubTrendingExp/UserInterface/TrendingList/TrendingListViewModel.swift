//
//  TrendingListViewMode.swift
//  GithubTrendingExp
//
//  Created by EVGENY SYSENKA on 15/07/2025.
//

import SwiftUI
import Observation

@MainActor
protocol TrendingListViewModelType: ViewModel {
    var state: ViewState<[Repository]> { get }
    var trendingList: [Repository] { get }
    var showOnlyFavorites: Bool { get set }
    var selectedDataRange: DateRange { get set }
    
    func isInFavorite(for id: Repository.ID) -> Bool
    func toggleFavorite(for id: Repository.ID) async
    
    func load() async
}

@MainActor
@Observable
final class TrendingListViewModel: TrendingListViewModelType {
    private let apiService: GithubSearchApi
    private let favoriteStore: FavoriteStoreType
    
    init(apiService: GithubSearchApi, favoriteStore: FavoriteStoreType) {
        self.apiService = apiService
        self.favoriteStore = favoriteStore
        
        Task {
            await fetchFavorites()
        }
    }
    
    //MARK: - View State.
    var state: ViewState<[Repository]> = .idle
    
    var showOnlyFavorites: Bool = false
    var trendingList: [Repository] {
        if showOnlyFavorites {
            return fetchedTrendingList.filter { favoriteSet.contains($0.id) }
        } else {
            return fetchedTrendingList
        }
    }
    
    var selectedDataRange: DateRange = .thisMonth {
        didSet {
            if oldValue != selectedDataRange {
                Task { await self.load() }
            }
        }
    }
    
    //MARK: - Favorite.
    private var favoriteSet = Set<Int>()
    
    private func fetchFavorites() async {
        favoriteSet = await favoriteStore.fetchFavorites()
    }
    
    func isInFavorite(for id: Repository.ID) -> Bool {
        favoriteSet.contains(id)
    }
    
    func toggleFavorite(for id: Int) async {
        await favoriteStore.toggleFavorite(id: id)
        await fetchFavorites()
    }
    
    //MARK: - Fetch Data.
    private var fetchedTrendingList: [Repository] = []
    
    func load() async {
        state = .loading
        
        do {
            let dateString = selectedDataRange.calculatedDateRange
            let list = try await apiService.fetchTrending(for: dateString)
            fetchedTrendingList = list
            
            if Bool.random() {
                state = .sucsess(list)
            } else {
                state = .error(ApiError.custom(message: "Testing"))
            }
        } catch {
            state = .error(error as? ApiError)
        }
    }
}
