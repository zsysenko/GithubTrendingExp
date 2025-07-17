//
//  LanguageFilterScreen.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 05/06/2025.
//

import SwiftUI

struct FilterScreen<Object: FilterObjectProtocol>: View {
    let viewModel: any FiltersViewModelProtocol<Object>
    
    var onSelect: (Object?) -> Void
    
    var body: some View {
        NavigationStack {
            List(viewModel.objects, id: \.self) { language in
                Button {
                    select(object: language)
                } label: {
                    HStack {
                        Text(language.title)
                        Spacer()
                        if viewModel.selectedObject == language {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            
            if viewModel.isOptionalAvailable {
                Button {
                    select(object: nil)
                } label: {
                    Text("Clear")
                        .frame(maxWidth: .infinity, maxHeight: 30)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 50)
            }
        }
    }
    
    private func select(object: Object?) {
        viewModel.selectedObject = object
        onSelect(object)
    }
}

#Preview {
    FilterScreen(
        viewModel: FiltersViewModel(
            objects: ["Swift", "Python"],
            selectedObject: "Swift",
            isOptionalAvailable: true
        ),
        onSelect: { object in }
    )
}
