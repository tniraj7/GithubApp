import Foundation
import Combine

class WebService {
    
    enum APIError: Error {
        case networkErrors(error: String)
        case responeError(error: String)
        case unknownError
    }
    
    
    static let shared = WebService()
    
    func getData<T: Decodable>(for url: String) -> AnyPublisher<T, Error> {
        
        guard let url = URL(string: url) else {  fatalError() }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = "GET"
        
        let decoder = JSONDecoder()
        
        let publisher = URLSession.shared.dataTaskPublisher(for:request)
            .retry(3)
            .receive(on: RunLoop.main)
            .map { $0.data }
            .mapError({ error -> Error in
                switch error {
                
                case URLError.cannotFindHost:
                    return APIError.networkErrors(error:"Cannot find host url")
                    
                case URLError.badURL:
                    return APIError.networkErrors(error:"Bad url")
                    
                default:
                    return APIError.responeError(error: error.localizedDescription)
                }
            })
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()

        return publisher
    }
}
