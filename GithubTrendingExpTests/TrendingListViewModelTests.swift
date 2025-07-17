//
//  TrendingListViewModelTests.swift
//  GithubTrendingExpTests
//
//  Created by EVGENY SYSENKA on 17/07/2025.
//

import XCTest
@testable import GithubTrendingExp

final class TrendingListViewModelTests: XCTestCase {

    var viewModel: TrendingListViewModelProtocol!
    var mockApi: MockGithubSearchApi!
    var mockFavoriteStore: MockFavoriteStore!

    override func setUp() async throws {
        try await super.setUp()
        
        mockApi = MockGithubSearchApi()
        mockFavoriteStore = await MockFavoriteStore()
        viewModel = await TrendingListViewModel(apiService: mockApi, favoriteStore: mockFavoriteStore)
    }
    
    @MainActor
    func testLoadTrendingListSuccess() async {
        let expectedRepos = [
            Repository.mock(id: 1, name: "A", language: "Swift"),
            Repository.mock(id: 2, name: "B", language: "Swift"),
            Repository.mock(id: 3, name: "C", language: "Python")
        ]
        await mockApi.set(repositories: expectedRepos)
        
        await viewModel.load()
        
        XCTAssertEqual(viewModel.state, .sucsess(expectedRepos))
        XCTAssertEqual(viewModel.trendingList.count, 3)
    }
    
    @MainActor
    func testToogleFavoriteListSuccess() async {
        let id = 99
        
        XCTAssertFalse(viewModel.isInFavorite(for: id))
        
        await viewModel.toggleFavorite(for: id)
        XCTAssertTrue(viewModel.isInFavorite(for: id))
        
        await viewModel.toggleFavorite(for: id)
        XCTAssertFalse(viewModel.isInFavorite(for: id))
    }
    
    @MainActor
    func testShowOnlyFavoritesFiltersList() async {
        let expectedRepos = [
            Repository.mock(id: 1, name: "A", language: "Swift"),
            Repository.mock(id: 2, name: "B", language: "Swift"),
            Repository.mock(id: 3, name: "C", language: "Python")
        ]
        await mockApi.set(repositories: expectedRepos)
        
        await viewModel.load()
        await viewModel.toggleFavorite(for: 1)
        
        XCTAssertEqual(viewModel.trendingList.count, 3)
        
        viewModel.showOnlyFavorites = true
        XCTAssertEqual(viewModel.trendingList.count, 1)
        XCTAssertEqual(viewModel.trendingList.first?.id, 1)
    }
}
