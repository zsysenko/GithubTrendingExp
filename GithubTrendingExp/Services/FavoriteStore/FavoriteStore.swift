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
    
    private var container: ModelContainer
    
    init(container: ModelContainer? = nil) {
        guard let container else {
            do {
                let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
                let container = try ModelContainer(for: FavoriteItem.self, configurations: configuration)
                self.container = container
            } catch {
                fatalError("Failed to initialize ModelContainer: \(error)")
            }
            return
        }
        self.container = container
    }
    
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
    
    func fetchFavorites() async -> Set<Repository.ID> {
        let descriptor = FetchDescriptor<FavoriteItem>()
        guard let items = try? container.mainContext.fetch(descriptor) else {
            return []
        }
        let set = Set(items.map{ $0.repoId })
        return set
    }
}
