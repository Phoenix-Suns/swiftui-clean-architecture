//
//  RepoListViewModel.swift
//  NghiaSwiftUIClear
//
//  Created by Nghia Tran on 6/5/23.
//

import Foundation
import Combine

@MainActor
class RepoListViewModel: ObservableObject {
    
    var getReposUseCase = GetReposUseCase(repo: RepoRepositoryImpl(dataSource: RepoAPIImpl()))
    @Published var repos: [Repo] = []
    @Published var errorMessage = ""
    @Published var hasError = false
    
    func getRepos(_ searchText: String = "a", page: Int8 = 0) async {
        errorMessage = ""

        let result = await getReposUseCase.execute(searchText: searchText, page: page)
        switch result{
        case .success(let repos):
            self.repos = repos
        case .failure(let error):
            self.repos = []
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
}
