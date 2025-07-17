//
//  AvatarView.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 09/06/2025.
//

import SwiftUI

struct AvatarView: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
            
        } placeholder: {
            Circle()
                .fill(.gray)
                .overlay {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.white)
                }
        }
    }
}

#Preview {
    AvatarView(url: nil)
        .frame(width: 100)
}
