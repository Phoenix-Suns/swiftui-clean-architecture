//
//  RepoAPIEntity.swift
//  NghiaSwiftUIClear
//
//  Created by Nghia Tran on 6/5/23.
//

import Foundation

struct GetReposEntity: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
    
    // MARK: - Item
    struct Item: Codable {
        let id: Int
        let name: String
        let owner: Owner
    }
    
    // MARK: - Owner
    struct Owner: Codable {
        let avatarURL: String

        enum CodingKeys: String, CodingKey {
            case avatarURL = "avatar_url"
        }
    }

}


