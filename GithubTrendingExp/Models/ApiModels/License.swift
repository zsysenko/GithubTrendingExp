//
//  License.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 06/06/2025.
//

import Foundation

struct License: Codable, Hashable, Equatable {
    let key: String
    let name: String
    let url: String?

    enum CodingKeys: String, CodingKey {
        case key
        case name
        case url
    }
}

extension License {
    static let mock = License(key: "mit", name: "MIT License", url: nil)
}
