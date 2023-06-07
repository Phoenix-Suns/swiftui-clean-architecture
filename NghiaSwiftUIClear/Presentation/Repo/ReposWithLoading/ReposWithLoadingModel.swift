//
//  RepoListViewModel.swift
//  NghiaSwiftUIClear
//
//  Created by Nghia Tran on 6/5/23.
//

import Foundation
import Combine

@MainActor
class ReposWithLoadingViewModel: ObservableObject {
    
    var getReposUseCase = GetReposUseCase(repo: RepoRepositoryImpl(dataSource: RepoAPIImpl()))
    @Published var repos: [Repo] = []
    @Published var errorMessage = ""
    @Published var hasError = false
    @Published var searchKey = ""
    @Published var loadingMore = true
    @Published var refreshing = true
    private var disposeBag = Set<AnyCancellable>()
    private var page: Int8 = 0
    
    init() {
        self.searchTextChange()
    }
    
    func searchTextChange() {
        $searchKey
            .debounce(for: 0.5, scheduler: RunLoop.main) // 0.5 second debounce
            // Called after 2 seconds when text stops updating (stoped typing)
            .sink {
                let searchText = $0
                Task {
                    await self.getRepos(searchText)
                }
            }
        .store(in: &disposeBag)
    }
    
    func getRepos(_ searchText: String, page: Int8 = 0) async {
        errorMessage = ""
        let searchStr = searchText != "" ? searchText : "a"
        self.page = page
        
        // Loading
        if page == 0 {
            refreshing = true
        } else {
            loadingMore = true
        }
        
        let result = await getReposUseCase.execute(searchText: searchStr, page: self.page)
        switch result{
        case .success(let repos):
            
            if page == 0 {
                // First page
                self.repos = repos
            } else {
                // Load More
                self.repos.append(contentsOf: repos)
            }
            loadingMore = false
            refreshing = false
        case .failure(let error):
            self.repos = []
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
    
    func getMoreRepos() async {
        let page = self.page + 1
        await self.getRepos(searchKey, page: page)
    }
}
