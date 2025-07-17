//
//  ViewState.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 08/06/2025.
//

import Foundation

// MARK: - ViewModel Protocol

enum ViewState<T: Equatable> {
    case idle
    case loading
    case sucsess(T)
    case error(Error?)
}

extension ViewState: Equatable {
    static func == (lhs: ViewState<T>, rhs: ViewState<T>) -> Bool {
        switch (lhs, rhs) {
            case (.idle, .idle), (.loading, .loading):
                return true
            case (.sucsess(let l), .sucsess(let r)):
                return l == r
            case (.error(let l), .error(let r)):
                return l?.localizedDescription == r?.localizedDescription
            default:
                return false
        }
    }
}


@MainActor
protocol ViewModel: AnyObject { }
