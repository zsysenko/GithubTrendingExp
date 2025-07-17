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
        ScrollView {
            headerView
                .padding(.bottom, 20)
            Divider()
                
            contentView
        }
        .searchable(text: $viewModel.searchText)
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
    private var contentView: some View {
        switch viewModel.state {
            case .loading:
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
                Spacer()
                
            case .sucsess:
                listView
                
            case .error:
                GenericErrorView() { Task { await viewModel.load()} }
                
            default:
                EmptyView()
        }
    }
    
    private var listView:  some View {
        ZStack {
            VStack {
                ForEach(viewModel.trendingList, id: \.self) { repository in
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
                    Divider()
                }
                .padding(.horizontal, 20)
            }
            
            if viewModel.trendingList.isEmpty {
                ContentUnavailableView(
                    "No Results Found",
                    systemImage: "magnifyingglass"
                )
                .frame(maxHeight: 150)
            }
        }
        .frame(maxWidth: .infinity)
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
            objects: Period.allCases,
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
