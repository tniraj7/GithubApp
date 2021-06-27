import Foundation

struct Item: Decodable, Identifiable {
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
