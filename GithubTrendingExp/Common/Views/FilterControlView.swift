//
//  SwiftUIView.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 06/06/2025.
//

import SwiftUI

struct FilterControlView: View {
    var selectedValue: String
    var isExpanded: Bool = false
    
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 5) {
                Text(selectedValue)
                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeIn(duration: 0.2), value: isExpanded)
            }
            .font(.callout)
        }
    }
}

#Preview {
    FilterControlView(selectedValue: "Any" ) {}
}
