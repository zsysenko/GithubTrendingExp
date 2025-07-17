//
//  ProjectDetail.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 05/06/2025.
//

import SwiftUI
import Observation

struct RepositoryDetailScreen: View {
    @Environment(\.verticalSizeClass) private var vSize
    
    @State private var viewModel: RepositoryDetailModel
    
    init(viewModel: RepositoryDetailModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            headerView
                .padding()
            
            languagesBlock
            
            Spacer()
        }
        .frame(maxWidth: 800)
        .onAppear {
            Task {
                await viewModel.load()
            }
        }
    }
    
    // MARK: - Languages block.
    
    @ViewBuilder
    private var languagesBlock: some View {
        switch viewModel.state {
            case.sucsess(let languages):
                LanguagesView(languages: languages)
                    .padding(.horizontal)
                
            case .idle, .loading:
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray)
                    .frame(maxHeight: 80)
                    .padding()
                
            case .error(_):
                EmptyView()
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 5) {
            RepoTitleView(
                repo: repository.name,
                owner: repository.owner.login
            )
            .font(.title3)
            
            HStack {
                PrivateBadge(isPrivate: repository.isPrivate)
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .padding(.vertical, 5)
                Spacer()
            }
            
            HStack {
                Text(repository.description ?? " - ")
                    .font(.subheadline)
                Spacer()
            }
            
            VStack(spacing: 5) {
                if let homepage = repository.homepage, homepage.count > 0 {
                    HStack {
                        HomepageBadge(homepage: homepage)
                        Spacer()
                    }
                }
                
                HStack(spacing: 10) {
                    StarsView(starsCount: repository.stargazersCount)
                    ForksView(forkCount: repository.forksCount)
                    WatchersView(watchersCount: repository.watchersCount)
                    
                    Spacer()
                    
                    if let license = repository.license {
                        LicenseBadge(license: license.name)
                            .font(.caption)
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.gray)
            }
            .font(.callout)
        }
    }
    
    private var repository: Repository {
        viewModel.repository
    }
}

#Preview {
    RepositoryDetailScreen(
        viewModel: RepositoryDetailModel(
            repository: Repository.mock(id: 1, name: "Test repo", language: "Swift"), apiService: ApiService()
        )
    )
}
