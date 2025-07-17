//
//  FavoriteItem.swift
//  GithubTrendingExp
//
//  Created by EVGENY SYSENKA on 16/07/2025.
//

import Foundation
import SwiftData

@Model
final class FavoriteItem {
    @Attribute(.unique) var repoId: Int

    init(repoId: Int) {
        self.repoId = repoId
    }
}
