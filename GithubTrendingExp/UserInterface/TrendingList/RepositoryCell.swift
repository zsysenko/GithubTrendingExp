//
//  RepositoryCell.swift
//  GithubTrendingExp
//
//  Created by EVGENY SYSENKA on 17/07/2025.
//

import SwiftUI

struct RepositoryCell: View {
    let repository: Repository
    @Binding var isInFavorite: Bool
    
    var avatarUrl: URL? {
        repository.owner.avatarUrl
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    AvatarView(url: avatarUrl)
                        .frame(maxWidth: 30)
                    
                    RepoTitleView(
                        repo: repository.name,
                        owner: repository.owner.login
                    )
                }
                
                Text(repository.description ?? " - ")
                    .font(.caption)
                
                HStack(spacing: 10) {
                    Text(repository.language ?? "")
                        .bold()
                    
                    StarsView(starsCount: repository.stargazersCount)
                    ForksView(forkCount: repository.forksCount)
                    Spacer()
                }
                .font(.caption)
            }
            Spacer()
            
            VStack {
                AppToggle(isOn: $isInFavorite)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    RepositoryCell(
        repository: Repository.mock(id: 1, name: "Test", language: "Swift"),
        isInFavorite: .constant(false)
    )
}
