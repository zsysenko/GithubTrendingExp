//
//  FavoriteToggle.swift
//  GithubTrendingExp
//
//  Created by EVGENY SYSENKA on 16/07/2025.
//

import Foundation
import SwiftUI

struct AppToggle: View {
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            Image(systemName: isOn ? "star.fill" : "star")
                .font(.system(size: 16).bold())
        }
        .contentTransition(.symbolEffect(.replace, options: .speed(2.0)))
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .toggleStyle(.button)
        .overlay {
            RoundedRectangle(cornerRadius: 10.0)
                .strokeBorder(.tint, lineWidth: isOn ? 0.0 : 1.0)
                .contentTransition(.opacity)
        }
    }
}
