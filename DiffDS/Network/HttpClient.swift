import Foundation
import Combine

class HttpClient {
    
    var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func makeHttpRequest<T: Codable>(for url: URL, httpMethod: String) -> AnyPublisher<T, Error>{
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = httpMethod
        
        return session.dataTaskPublisher(for:request)
            .receive(on: DispatchQueue.main)
            .mapError({ error -> Error in
                switch error {
                    
                case URLError.cannotFindHost:
                    return APIError.networkError(error:"Cannot find host url")
                    
                case URLError.badURL:
                    return APIError.networkError(error:"Bad url")
                    
                default:
                    return APIError.unknownError(reason: error.localizedDescription)
                }
            })
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
    }
}
