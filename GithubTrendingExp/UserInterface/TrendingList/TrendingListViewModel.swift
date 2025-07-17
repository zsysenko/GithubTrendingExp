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
    var selectedDataRange: Period { get set }
    var searchText: String { get set }
    
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
    
    var searchText: String = ""
    
    //MARK: - View State.
    
    var state: ViewState<[Repository]> = .idle
    
    var showOnlyFavorites: Bool = false
    var trendingList: [Repository] {
        guard !searchText.isEmpty else { return favoriteList }
        
        return favoriteList.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.owner.login.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var favoriteList: [Repository] {
        if showOnlyFavorites {
            return fetchedTrendingList.filter { favoriteSet.contains($0.id) }
        } else {
            return fetchedTrendingList
        }
    }
    
    var selectedDataRange: Period = .thisMonth {
        didSet {
            if oldValue != selectedDataRange {
                
                // Drop filters when uploading new results.
                showOnlyFavorites = false
                searchText = ""
                
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
            state = .sucsess(list)
            
// Used to simulate errors response. Add if needed.
//            if [true, true, true, false].randomElement()! {
//                state = .sucsess(list)
//            } else {
//                state = .error(ApiError.custom(message: "Testing"))
//            }
        } catch {
            state = .error(error as? ApiError)
        }
    }
}
