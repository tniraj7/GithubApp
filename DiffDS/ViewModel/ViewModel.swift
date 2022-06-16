import Foundation
import Combine

class ViewModel {
    
    private let repository: GithubDataFacade
    private(set) var disposable = Set<AnyCancellable>()
    private(set) var repositories = CurrentValueSubject<[Item], Never>([])
    private(set) var error = CurrentValueSubject<String?, Never>(nil)
    private(set) var isLoading = CurrentValueSubject<Bool, Never>(false)
    var keyword = CurrentValueSubject<String, Never>("")
    
    init(_ repository: GithubDataFacade) {
        self.repository = repository
        getRepositories()
    }
    
    func getRepositories() {
        isLoading.send(true)
        
        keyword
            .dropFirst()
            .filter { !$0.isEmpty }
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .sink { string in
                
                self.repository
                    .getRepositories(keyword: string)
                    .sink(receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            self?.error.send(error.localizedDescription)
                            self?.isLoading.send(false)
                        case .finished:
                            self?.isLoading.send(false)
                        }
                    }) { [weak self] response in
                        self?.repositories.send(response.items)
                    }.store(in: &self.disposable)
                
            }.store(in: &disposable)
    }
}
