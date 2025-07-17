//
//  MockFavoriteStore.swift
//  GithubTrendingExpTests
//
//  Created by EVGENY SYSENKA on 17/07/2025.
//

import Foundation

final class MockFavoriteStore: FavoriteStoreType {
    private var favoriteIDs: Set<Int> = []
    
    func fetchFavorites() async -> Set<Int> {
        favoriteIDs
    }

    func toggleFavorite(id: Int) async {
        if favoriteIDs.contains(id) {
            favoriteIDs.remove(id)
        } else {
            favoriteIDs.insert(id)
        }
    }
}
