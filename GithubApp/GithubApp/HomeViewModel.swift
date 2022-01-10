import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    
    private let disposeBag = DisposeBag()
    
    func getRepositories(_ searchString: Observable<String>) -> Observable<[Item]> {
        return searchString.asObservable()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { $0.lowercased() }
            .filter { $0.allSatisfy({ $0.isLetter }) }
            .flatMap {
                self.makeRequest($0)
                    .map { $0.items ?? [] }
            }
    }
    
    private func makeRequest(_ keyword: String) -> Observable<GithubAPIResponse> {
        let finalUrl = URL(string: "https://api.github.com/search/repositories?q=\(keyword)")!
        let request = URLRequest(url: finalUrl)
        
        return URLSession.shared.rx.response(request: request)
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
            .map { (_, data: Data) in
                return try JSONDecoder().decode(GithubAPIResponse.self, from: data)
            }
            .retry(2)
            .catchAndReturn(.init(items: []))
            .observe(on: MainScheduler.asyncInstance)
            .share(replay: 1, scope: .whileConnected)
    }
}
