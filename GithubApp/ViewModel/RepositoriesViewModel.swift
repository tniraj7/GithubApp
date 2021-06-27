import Foundation
import UIKit
import Combine

class RepositoriesViewModel: ObservableObject {
    
    @Published var searchKeyword = String()
    @Published private(set) var repositoryList: [Item]? = nil
    @Published private(set) var isLoading = Bool()
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        fetchRepositories()
    }
    
    func searchRepositories(for keyword: String) {
        isLoading = true
        
        let keyword = keyword.replacingOccurrences(of: " ", with: "%20")
        
        GithubService.getRepositories(for: keyword)
            .map { $0.items }
            .sink { completion in
                
                switch completion {
                
                case .finished: break
                    
                case .failure(let error):
                    self.isLoading = false
                    print(error.localizedDescription)
                    
                }
            } receiveValue: { [weak self] items in
                self?.repositoryList = items
                self?.isLoading = false
            }
            .store(in: &cancellable)
    }
    
    func fetchRepositories() {
        
        $searchKeyword
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] keyword in
                if (
                    keyword.contains(where: { $0.isWhitespace}) ||
                        keyword.contains(where: { $0.isNumber}) ||
                        keyword.allSatisfy({ $0.isLetter })
                ) {
                    self?.searchRepositories(for: keyword)
                }
            }
            .store(in: &cancellable)
    }
    
}

