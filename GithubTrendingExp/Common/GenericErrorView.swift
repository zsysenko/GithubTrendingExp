//
//  ErrorView.swift
//  GithubTrendingExp
//
//  Created by EVGENY SYSENKA on 17/07/2025.
//

import SwiftUI

struct GenericErrorView: View {
    var message: String = "Something went wrong"
    var retryAction: (() -> Void)?

    var body: some View {
        ContentUnavailableView(
            message,
            systemImage: "exclamationmark.triangle",
            description: Text("Please try again later or check your internet connection.")
        )
        .frame(maxHeight: 200)
        
        if let retryAction = retryAction {
            Button("Retry") {
                retryAction()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
#Preview {
    GenericErrorView() {}
}
