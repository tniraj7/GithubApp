import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    
    private let disposeBag = DisposeBag()
    
    func getRepositories(_ searchString: Observable<String>) -> Observable<[Item]> {
        return searchString.asObservable()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter {( $0.allSatisfy({ $0.isLetter }) && $0.count>0 )}
            .flatMap {
                self.makeRequest($0)
                    .map { response in
                        return response.items ?? [Item]()
                    }
            }

    }
    
    private func makeRequest(_ keyword: String) -> Observable<GithubAPIResponse> {
        let finalUrl = URL(string: "https://api.github.com/search/repositories?q=\(keyword)")!
        let request = URLRequest(url: finalUrl)
        
        return URLSession.shared.rx.data(request: request)
            .map { data in
                try JSONDecoder().decode(GithubAPIResponse.self, from: data)
            }
            .observe(on: MainScheduler.asyncInstance)
    }
}
