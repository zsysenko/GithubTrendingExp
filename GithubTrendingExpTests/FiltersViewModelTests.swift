//
//  FiltersViewModelTests.swift
//  GithubTrendingExpTests
//
//  Created by EVGENY SYSENKA on 17/07/2025.
//

import XCTest
@testable import GithubTrendingExp

final class FiltersViewModelTests: XCTestCase {
    
    typealias ViewModel = FiltersViewModel<String>
    
    func testInitWithDefaultValues() {
        let items = ["Swift", "Kotlin", "Dart"]
        let viewModel = ViewModel(objects: items, selectedObject: nil)
        
        XCTAssertEqual(viewModel.objects, items)
        XCTAssertNil(viewModel.selectedObject)
        XCTAssertFalse(viewModel.isOptionalAvailable)
    }
    
    func testInitWithSelectedObject() {
        let items = ["Swift", "Kotlin", "Dart"]
        let viewModel = ViewModel(objects: items, selectedObject: "Kotlin")
        
        XCTAssertEqual(viewModel.objects, items)
        XCTAssertEqual(viewModel.selectedObject, "Kotlin")
    }
    
    func testSelectRemoveObject() {
        let items = ["Swift", "Kotlin", "Dart"]
        let viewModel = ViewModel(objects: items, selectedObject: "Kotlin", isOptionalAvailable: true)
        
        viewModel.selectedObject = "Swift"
        XCTAssertEqual(viewModel.selectedObject, "Swift")
        
        viewModel.selectedObject = nil
        XCTAssertNil(viewModel.selectedObject)
    }
}
