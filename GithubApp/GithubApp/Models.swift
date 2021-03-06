import Foundation

struct GithubAPIResponse: Decodable {
    var items: [Item]?
}

struct Item: Decodable, Identifiable, Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.name == rhs.name
    }
    
    var id: Int
    var name: String
    var full_name: String
    var owner: Owner
    var html_url: String
    var description: String?
    var fork: Bool
    var url: String
    var homepage: String?
    var size: Int
    var language: String?
    var license: License?
    var forks, watchers: Int
    var score: Int
    var stargazers_count: Int
    var watchers_count: Int
    var forks_count: Int
    
}

struct License: Decodable {
    var name: String
}

struct Owner: Decodable {
    var login: String
    var avatar_url: String
}
