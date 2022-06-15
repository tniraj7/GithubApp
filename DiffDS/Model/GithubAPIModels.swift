import Foundation

// MARK: - GithubAPIResponse
struct GithubAPIResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Item]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - Item
struct Item: Codable, Hashable {
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
      lhs.id == rhs.id
    }
    
    let id: Int
    let owner: Owner
    let fullName: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case owner
    }
}

// MARK: - Owner
struct Owner: Codable {
    let id: Int
    let avatarURL: String
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
}
