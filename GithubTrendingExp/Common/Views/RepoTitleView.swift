//
//  RepoTitleView.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 07/06/2025.
//

import SwiftUI

struct RepoTitleView: View {
    let repo: String
    let owner: String
    
    var body: some View {
        HStack {
            Text("\(repo) \\ ")
            +
            Text("\(owner)")
                .bold()
            
            Spacer()
        }
        .foregroundStyle(.blue)
    }
}

#Preview {
    VStack {
        RepoTitleView(repo: "Repo name", owner: "Short")
            .padding(.bottom, 100)
        
        RepoTitleView(
            repo: "Very very long repo Repo name",
            owner: "Very very long Owner name"
        )
    }
    .padding()
    .font(.title)
    
}
