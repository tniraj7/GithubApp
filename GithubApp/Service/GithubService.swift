import Foundation
import Combine

struct GithubService {
    
    static func getRepositories(for searchString: String) -> AnyPublisher<GithubAPIResponse, Error> {
        let url = "https://api.github.com/search/repositories?q=\(searchString)"
        return WebService.shared.getData(for: url)
    }
}
