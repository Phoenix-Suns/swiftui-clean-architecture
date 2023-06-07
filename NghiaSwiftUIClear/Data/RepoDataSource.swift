//
//  RepoDataSource.swift
//  NghiaSwiftUIClear
//
//  Created by Nghia Tran on 6/5/23.
//

import Foundation

protocol RepoDataSource{
    
    func getRepos(searchText: String, page: Int8) async throws -> [Repo]
    
}
