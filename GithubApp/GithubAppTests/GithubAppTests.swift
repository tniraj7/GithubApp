import XCTest
@testable import GithubApp

class GithubServiceSpy: GithubService {
    private(set) var loadRepositoriesAPICallCount: Int = 0
    private let result: Result<[Item]?, Error>
    
    init(result: [Item] = []) {
        self.result = .success(result)
    }

    func loadGithubRepositoryData(keyword: String, completion: @escaping ((Result<[Item]?, Error>) -> Void)) {
        loadRepositoriesAPICallCount += 1
        completion(result)
    }
}

class GithubAppTests: XCTestCase {

    func test_viewDidLoad_doesntLoadGithubRepositoryData() {
        
        let service = GithubServiceSpy()
        let sut = SearchViewController(service: service)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(service.loadRepositoriesAPICallCount, 0)
    }
    
    func test_viewWillAppear_loadsRepositoriesData() {
        let service = GithubServiceSpy()
        let sut = SearchViewController(service: service)
        
        sut.simulateViewWillAppear()
        
        XCTAssertEqual(service.loadRepositoriesAPICallCount, 1)
    }
    
    func test_viewWillAppear_SuccessfullAPIResponse_showsRepositories() {
        
        let repositoryItem1 = Item(id: 1, name: "Angular", full_name: "", owner: Owner(login: "", avatar_url: ""), html_url: "", description: "", fork: false, url: "", homepage: "", size: 1, language: "", license: nil, forks: 1, watchers: 1, score: 1, stargazers_count: 1, watchers_count: 1, forks_count: 1)
        
        let repositoryItem2 = Item(id: 1, name: "Redux", full_name: "", owner: Owner(login: "", avatar_url: ""), html_url: "", description: "", fork: false, url: "", homepage: "", size: 1, language: "", license: nil, forks: 1, watchers: 1, score: 1, stargazers_count: 1, watchers_count: 1, forks_count: 1)
        
        let service = GithubServiceSpy(result: [repositoryItem1, repositoryItem2])
        let sut = SearchViewController(service: service)
        sut.view.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        sut.simulateViewWillAppear()
        
        XCTAssertEqual(sut.numberOfRepositories(), 2)
        
        XCTAssertEqual(sut.repositoryName(at: 0), repositoryItem1.name)
        XCTAssertEqual(sut.repositoryName(at: 1), repositoryItem2.name)
    }

}

private extension SearchViewController {
    func simulateViewWillAppear() {
        loadViewIfNeeded()
        beginAppearanceTransition(true, animated: false)
    }
    
    func numberOfRepositories() -> Int {
        tableView.numberOfRows(inSection: section)
    }
    
    func repositoryName(at row: Int) -> String {
        repositoryCell(at: row)?.textLabel?.text ?? ""
    }
    
    private func repositoryCell(at row: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: row, section: section)
        return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }
    
    private var section : Int { 0 }
}
