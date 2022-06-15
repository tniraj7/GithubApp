import Foundation
import Combine

class GithubDataFacade {
    
    private let service: GithubService
    
    init(_ service: GithubService) {
        self.service = service
    }
    
    func constructURL(keyword : String) -> URL {
        var components = URLComponents()
        components.scheme = githubScheme
        components.host = githubHost
        components.path = githubPath
        components.queryItems = [
            URLQueryItem(name: githubQueryParameter, value: keyword),
        ]
        return components.url!
    }
    
    func getRepositories(keyword : String) -> AnyPublisher<GithubAPIResponse, Error> {
        let url = constructURL(keyword: keyword)
//        return Fail<GithubAPIResponse?, Error>.init(error: URLError.init(.badURL) ).eraseToAnyPublisher()
        return service.getGithubRepositoryData(for: url)
    }
}
