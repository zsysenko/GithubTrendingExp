//
//  LanguagesView.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 07/06/2025.
//

import SwiftUI

struct LanguagesView: View {
    var languages: [Language]
    
    var total: Double {
        Double(languages.map { $0.value }.reduce(0, +))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                languageBar(geometry: geometry)
                languageAnnotationsView
            }
            .frame(maxWidth: geometry.size.width)
        }
        .frame(maxHeight: 65)
    }
    
    private func languageBar(geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            
            ForEach(languages, id: \.name) { language in
                let width = geometry.size.width * (Double(language.value) / total)
                Rectangle()
                    .fill(language.color)
                    .frame(width: width)
            }
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var languageAnnotationsView: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(languages, id: \.name) { language in
                    let precent = Double(language.value) / total * 100
                    if precent > 0.05 {
                        LanguageBadge(
                            language: language.name,
                            color: language.color,
                            precent: precent
                        )
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

struct LanguageBadge: View {
    let language: String
    let color: Color
    let precent: Double
    
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            
            Text(language)
                .font(.caption)
            
            Text(String(format: "%.1f", precent) + "%")
                .font(.caption)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    LanguagesView(languages: [
        Language(name: "Swift", value: 70),
        Language(name: "Python", value: 30)
    ])
    .padding()
}
