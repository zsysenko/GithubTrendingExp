//
//  ForksView.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 06/06/2025.
//

import SwiftUI

struct ForksView: View {
    let forkCount: Int
    
    var body: some View {
        HStack {
            Image(systemName: "tuningfork")
            Text("\(forkCount)")
        }
    }
}

struct StarsView: View {
    let starsCount: Int
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "star")
            Text("\(starsCount)")
        }
    }
}

struct WatchersView: View {
    let watchersCount: Int
    
    var body: some View {
        HStack {
            Image(systemName: "eyes.inverse")
            Text("\(watchersCount)")
        }
    }
}

struct LicenseBadge: View {
    let license: String
    
    var body: some View {
        HStack {
            Image(systemName: "scroll")
            
            Text(license)
        }
    }
}

struct HomepageBadge: View {
    let homepage: String
    
    var body: some View {
        HStack {
            Image(systemName: "link")
                .foregroundStyle(.gray)
            
            Text(homepage)
                .foregroundStyle(.blue)
        }
        .bold()
    }
}

struct PrivateBadge: View {
    let isPrivate: Bool
    
    var body: some View {
        HStack {
            if isPrivate {
                Image(systemName: "lock.fill")
            }
            Text(isPrivate ? "Private" : "Public")
                .fontWeight(.medium)
        }
        .padding(3)
        .padding([.leading, .trailing], 8)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(.gray, lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 30) {
        ForksView(forkCount: 10)
        WatchersView(watchersCount: 120)
        StarsView(starsCount: 2000)
        HomepageBadge(homepage: "www.featured.com")
        LicenseBadge(license: "MIT License")
        PrivateBadge(isPrivate: false)
        PrivateBadge(isPrivate: true)
    }
    .foregroundStyle(.gray)
    .preferredColorScheme(.light)
    .border(.green)
}
