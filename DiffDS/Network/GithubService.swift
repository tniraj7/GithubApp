import Foundation
import Combine


enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

enum APIError: Swift.Error {
    case networkError(error: String)
    case responeError(error: String)
    case unknownError(reason: String)
}

class GithubService {
    
    let client: HttpClient
    
    init(client: HttpClient) {
        self.client = client
    }
    
    func getGithubRepositoryData(for url: URL) -> AnyPublisher<GithubAPIResponse, Error> {
        return client.makeHttpRequest(for: url, httpMethod: .get)
    }
    
    func getGithubAvatarImage(for url: URL) -> AnyPublisher<Data, Error> {
        return client.makeHttpRequest(for: url, httpMethod: .get)
    }
}

