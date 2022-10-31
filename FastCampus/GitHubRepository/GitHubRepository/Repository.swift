//
//  Repository.swift
//  GitHubRepository
//
//  Created by DongKyu Kim on 2022/10/31.
//

import Foundation

struct Repository: Decodable {
    let id: Int
    let name: String
    let description: String
    let stargazersCount: Int
    let language: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, language // API key와 동일
        case stargazersCount = "stargazers_count"
    }
}
