//
//  FavoriteStore.swift
//  GithubTrendingExp
//
//  Created by EVGENY SYSENKA on 16/07/2025.
//

import Foundation
import SwiftData

@MainActor
protocol FavoriteStoreType {
    func fetchFavorites() async -> Set<Int>
    func toggleFavorite(id: Int) async
}

@MainActor
final class FavoriteStore: FavoriteStoreType {
    
    lazy private var container: ModelContainer = {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
            self.container = try ModelContainer(for: FavoriteItem.self, configurations: configuration)
            return container
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }()
    
    func toggleFavorite(id: Int) async {
        let context = container.mainContext
        
        if let item = try? context.fetch(FetchDescriptor<FavoriteItem>(predicate: #Predicate { $0.repoId == id })).first {
            context.delete(item)
        } else {
            let newFavorite = FavoriteItem(repoId: id)
            context.insert(newFavorite)
        }
        try? context.save()
    }
    
    // MARK: - Private
    func fetchFavorites() async -> Set<Repository.ID> {
        let descriptor = FetchDescriptor<FavoriteItem>()
        guard let items = try? container.mainContext.fetch(descriptor) else {
            return []
        }
        let set = Set(items.map{ $0.repoId })
        return set
    }
}
