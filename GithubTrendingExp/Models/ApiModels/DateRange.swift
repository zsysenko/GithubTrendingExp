//
//  DateRange.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 22/06/2025.
//

import Foundation

enum DateRange: CaseIterable {
    case today
    case thisWeek
    case thisMonth
    
    private var value: Int {
        switch self {
        case .today: -1
        case .thisWeek: -7
        case .thisMonth: -30
        }
    }
    
    var calculatedDateRange: String {
        guard let date = Calendar.current.date(byAdding: .day, value: value, to: Date()) else { return "" }
        
        let stringDate = date.string(with: .apiDate)
        return stringDate
    }
}

extension DateRange: FilterObjectProtocol {
    var title: String {
        switch self {
        case .today: "Today"
        case .thisWeek: "This Week"
        case .thisMonth: "This Month"
        }
    }
}
