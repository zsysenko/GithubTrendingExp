//
//  TrendingList.swift
//  GithubTrendingExp
//
//  Created by EVGENY SYSENKA on 15/07/2025.
//

import SwiftUI

enum ActiveFilter: Identifiable  {
    case dateRangeFilter
    
    var id: UUID {
        UUID()
    }
}

struct TrendingListScreen: View {
    @Environment(AppCoordinator.self) private var coordinator
    
    @State private var viewModel: TrendingListViewModelType
    @State private var selectedFilter: ActiveFilter? = nil
    
    init(viewModel: TrendingListViewModelType) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            headerView
            listView
            
            Spacer()
        }
        .navigationTitle("Trending")
        .onAppear {
            Task {
                guard viewModel.trendingList.isEmpty else { return }
                await viewModel.load()
            }
        }
        .sheet(item: $selectedFilter, content: { selectedFilter in
            switch selectedFilter {
                case .dateRangeFilter:
                    dateRangeFiltersScreen
            }
        })
    }
    
    private var headerView: some View {
        VStack(spacing: 5) {
            HStack {
                Text("See what the GitHub community is most excited about.")
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            filtersControll
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var listView: some View {
        switch viewModel.state {
            case .loading:
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
                Spacer()
                
            case .sucsess:
                contentView
                
            case .error:
                GenericErrorView() { Task { await viewModel.load()} }
                
            default:
                EmptyView()
        }
    }
    
    private var contentView:  some View {
        VStack(spacing: 10) {
            List(viewModel.trendingList, rowContent: { repository in
                RepositoryCell(
                    repository: repository,
                    isInFavorite: Binding<Bool>(
                        get: {
                            viewModel.isInFavorite(for: repository.id)
                        },
                        set: { _ in
                            Task { await viewModel.toggleFavorite(for: repository.id) }
                        }
                    )
                )
                .onTapGesture {
                    coordinator.push(.repositoryDetail(repo: repository))
                }
            })
            .frame(maxWidth: 700, alignment: .center)
            .overlay {
                if viewModel.trendingList.isEmpty {
                    VStack {
                        ContentUnavailableView(
                            "No Results Found",
                            systemImage: "magnifyingglass"
                        )
                        .frame(maxHeight: 150)
                        Spacer()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            Color(uiColor: UIColor.systemGroupedBackground)
        )
    }
    
    private var filtersControll: some View {
        HStack() {
            FilterControlView(
                selectedValue: viewModel.selectedDataRange.title,
                isExpanded: selectedFilter == .dateRangeFilter
            ) {
                selectedFilter = .dateRangeFilter
            }
            Spacer()
            HStack {
                AppToggle(isOn: $viewModel.showOnlyFavorites)
            }
        }
    }
    
    private var dateRangeFiltersScreen: some View {
        let dateFilterViewModel = FiltersViewModel(
            objects: DateRange.allCases,
            selectedObject: viewModel.selectedDataRange
        )
        return FilterScreen(
            viewModel: dateFilterViewModel,
            onSelect: { range in
                self.selectedFilter = nil
                self.viewModel.selectedDataRange = range ?? .thisMonth
            }
        )
    }
}

#Preview {
    TrendingListScreen(
        viewModel: TrendingListViewModel(
            apiService: ApiService(),
            favoriteStore: FavoriteStore()
        )
        
    )
    .environment(AppCoordinator(dependencies: .preview ))
}
