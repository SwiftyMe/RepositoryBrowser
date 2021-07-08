//
//  RepositoryModel.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 15/04/2021.
//

import Foundation

///
/// Top level model struct (json-decodable)
///
struct RepositoriesModel: Decodable {
    let incompleteResults: Bool
    let items: [RepositoryModel]
    let totalCount: Int
}
    
extension RepositoriesModel {
    enum CodingKeys: String, CodingKey {
        case incompleteResults = "incomplete_results"
        case items
        case totalCount = "total_count"
    }
}

struct RepositoryModel: Decodable {
    let id: Int
    var name: String
    var fullName: String
    var description: String?
    let language: String?
    let releasesUrl: String?
    let openIssuesCount: Int?
    let stargazersCount: Int?
    let forksCount: Int?
    let owner: OwnerModel
    
    init(id:Int, org:String, name:String, description:String) {
        self.id = id
        self.name = name
        self.fullName = org + "/" + name
        self.description = description
        self.owner = OwnerModel(avatarURL:"")
        self.language = "Swift"
        self.openIssuesCount = 0
        self.stargazersCount = 0
        self.forksCount = 0
        self.releasesUrl = nil
    }
}

extension RepositoryModel {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case releasesUrl = "releases_url"
        case description
        case language
        case owner
        case openIssuesCount = "open_issues_count"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
    }
}

struct OwnerModel: Decodable {
    let avatarURL: String?
}

extension OwnerModel {
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}


struct RepositoryReleaseModel: Decodable {
    let id: Int
    let publishedAt: String
    let tagName: String
}

extension RepositoryReleaseModel {
    
    enum CodingKeys: String, CodingKey {
        case id
        case publishedAt = "published_at"
        case tagName = "tag_name"
    }
}
