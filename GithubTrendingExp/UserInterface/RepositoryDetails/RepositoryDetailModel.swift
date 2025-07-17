//
//  RepositoryDetailModel.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 06/06/2025.
//

import Foundation

@MainActor
protocol RepositoryDetailViewModelType: AnyObject {
    var repository: Repository { get }
    var state: ViewState<[Language]> { get set }

    func load() async
}

@MainActor
@Observable
final class RepositoryDetailModel: RepositoryDetailViewModelType {
    private let apiService: GithubRepoApi
    
    let repository: Repository
    var state: ViewState<[Language]> = .idle
    
    init(
        repository: Repository,
        apiService: GithubRepoApi
    ) {
        self.repository = repository
        self.apiService = apiService
    }
    
    func load() async {
        Task {
            await fetchLanguages()
        }
    }
    
    private func fetchLanguages() async {
        state = .loading
        
        do {
            let languages = try await apiService.fetchLanguages(owner: owner , repo: repo)
            let languagesSorted = languages.sorted {$0.value > $1.value}
            
            state = .sucsess(languagesSorted)
            
        } catch {
            print(error.localizedDescription)
            state = .error(error)
        }
    }
    
    // MARK: - Private
    private var owner: String {
        return repository.owner.login
    }
    
    private var repo: String {
        return repository.name
    }
}
