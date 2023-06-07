//
//  RepoAPIImpl.swift
//  NghiaSwiftUIClear
//
//  Created by Nghia Tran on 6/5/23.
//

import Foundation

enum APIServiceError: Error{
    case badUrl, requestError, decodingError, statusNotOK
}

struct RepoAPIImpl: RepoDataSource{
    
    
    func getRepos(searchText: String, page: Int8) async throws -> [Repo] {
        do {
            let urlStr = "\(Constants.BASE_URL)search/repositories?q=\(searchText)&page=\(page)"
            print("url: \(urlStr)")
            guard let url = URL(string: urlStr) else{
                throw APIServiceError.badUrl
            }

            guard let (data, response) = try? await URLSession.shared.data(from: url) else {
                throw APIServiceError.requestError
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("response: \(response)")  // 403: wait a minute to continue
                throw APIServiceError.statusNotOK
            }
            
            //let dataStr = String(decoding: data, as: UTF8.self)
            //print("data return: \(dataStr)")

            guard let result = try? JSONDecoder().decode(GetReposEntity.self, from: data) else {
                throw APIServiceError.decodingError
            }
            
            return result.items.map({ item in
                Repo(
                    id: item.id,
                    name: item.name,
                    avatarURL: item.owner.avatarURL
                )
            })
        } catch {
            print("/// \(error)")
            throw APIServiceError.requestError
        }
    }
}
