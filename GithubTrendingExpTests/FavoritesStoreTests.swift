//
//  FavoritesStoreTests.swift
//  GithubTrendingExpTests
//
//  Created by EVGENY SYSENKA on 24/07/2025.
//

import XCTest
import SwiftData

@testable import GithubTrendingExp

@MainActor
final class FavoriteStoreTests: XCTestCase {

    var store: FavoriteStoreType!
    var container: ModelContainer!

    override func setUpWithError() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: FavoriteItem.self, configurations: configuration)
        store = FavoriteStore(container: container)
    }

    func testToggleFavorite_AddsFavorite() async throws {
        let repoId = 999

        await store.toggleFavorite(id: repoId)
        let favorites = await store.fetchFavorites()

        XCTAssertTrue(favorites.contains(repoId), "Repo should be added to favorites")
    }

    func testToggleFavorite_RemovesFavorite() async throws {
        let repoId = 998

        await store.toggleFavorite(id: repoId) // Add
        await store.toggleFavorite(id: repoId) // Remove
        let favorites = await store.fetchFavorites()

        XCTAssertFalse(favorites.contains(repoId), "Repo should be removed from favorites")
    }

    func testFetchFavorites_InitiallyEmpty() async throws {
        let favorites = await store.fetchFavorites()
        XCTAssertTrue(favorites.isEmpty, "Initial favorites should be empty")
    }
}
