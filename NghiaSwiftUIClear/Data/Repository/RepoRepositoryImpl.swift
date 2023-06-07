//
//  RepoRepositoryImpl.swift
//  NghiaSwiftUIClear
//
//  Created by Nghia Tran on 6/5/23.
//

import Foundation

struct RepoRepositoryImpl: RepoRepository{
    
    var dataSource: RepoDataSource
    
    func getRepos(searchText: String, page: Int8) async throws -> [Repo] {
        let _repos =  try await dataSource.getRepos(searchText: searchText, page: page)
        return _repos
    }
}
