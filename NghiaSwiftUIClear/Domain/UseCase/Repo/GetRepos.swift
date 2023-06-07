//
//  GetRepos.swift
//  NghiaSwiftUIClear
//
//  Created by Nghia Tran on 6/5/23.
//

import Foundation

enum UseCaseError: Error{
    case networkError, decodingError
}

protocol GetRepos {
    func execute(searchText: String, page: Int8) async -> Result<[Repo], UseCaseError>
}

struct GetReposUseCase: GetRepos {
    var repo: RepoRepository
    
    func execute(searchText: String, page: Int8) async -> Result<[Repo], UseCaseError>{
        do {
            let repos = try await repo.getRepos(searchText: searchText, page: page)
            return .success(repos)
        } catch (let error) {
            print("usercase error: \(error)")
            switch(error){
            case APIServiceError.decodingError:
                return .failure(.decodingError)
            default:
                return .failure(.networkError)
            }
        }
    }
}
