//
//  FiltersViewModel.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 22/06/2025.
//

import SwiftUI
 
protocol FilterObjectProtocol: Equatable, Hashable {
    var title: String { get }
}

extension String: FilterObjectProtocol {
    var title: String {
        return self
    }
}

protocol FiltersViewModelProtocol<Object>: AnyObject {
    associatedtype Object: FilterObjectProtocol
    
    var objects: [Object] { get }
    var selectedObject: Object? { get set }
    var isOptionalAvailable: Bool { get }
}

final class FiltersViewModel<Object: FilterObjectProtocol>: FiltersViewModelProtocol{
    
    let objects: [Object]
    var selectedObject: Object?
    var isOptionalAvailable: Bool
    
    init(
        objects: [Object],
        selectedObject: Object?,
        isOptionalAvailable: Bool = false
    ) {
        self.objects = objects
        self.isOptionalAvailable = isOptionalAvailable
        self.selectedObject = selectedObject
    }
}
