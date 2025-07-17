//
//  Date+Formatter.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 05/06/2025.
//

import Foundation

extension DateFormatter {
    static let apiDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
}

extension Date {
    func string(with formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
}

extension String {
    func date(with formatter: DateFormatter) -> Date? {
        return formatter.date(from: self)
    }
}
