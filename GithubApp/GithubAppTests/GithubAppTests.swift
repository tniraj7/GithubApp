import XCTest
@testable import GithubApp

class GithubServiceSpy: GithubService {
    private(set) var loadRepositoriesAPICallCount: Int = 0
    private var results: [Result<[Item]?, Error>]
    
    
    init(result: [Item] = []) {
        self.results = [.success(result)]
    }
    
    init(results: [Result<[Item]?, Error>]) {
        self.results = results
    }

    func loadGithubRepositoryData(keyword: String, completion: @escaping ((Result<[Item]?, Error>) -> Void)) {
        loadRepositoriesAPICallCount += 1
        completion(results.removeFirst())
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
        
        sut.assert(isRendering: [repositoryItem1, repositoryItem2])
    }
    
    func test_viewWillAppear_failedAPIResponse_3times_showsError() {
        
        let service = GithubServiceSpy(results: [
            Result.failure(AnyError(errorDescription: "1st error")),
            Result.failure(AnyError(errorDescription: "2nd error")),
            Result.failure(AnyError(errorDescription: "3rd error"))
        ])
        let sut = TestableSearchViewController(service: service)
        
        sut.simulateViewWillAppear()
        
        XCTAssertEqual(sut.errorMessage(), "3rd error")
    }
    
    func test_viewWillAppear_successAfterFailedAPIResponse_1time_showsRepositories() {
        
        
        let repositoryItem1 = Item(id: 1, name: "Angular", full_name: "", owner: Owner(login: "", avatar_url: ""), html_url: "", description: "", fork: false, url: "", homepage: "", size: 1, language: "", license: nil, forks: 1, watchers: 1, score: 1, stargazers_count: 1, watchers_count: 1, forks_count: 1)
        
        let service = GithubServiceSpy(results: [
            Result.failure(AnyError(errorDescription: "1st error")),
            Result.success([repositoryItem1])
        ])
        
        let sut = TestableSearchViewController(service: service)
        
        sut.simulateViewWillAppear()
        
        sut.assert(isRendering: [repositoryItem1])
    }
    
    func test_viewWillAppear_successAfterFailedAPIResponse_2times_showsRepositories() {
        
        
        let repositoryItem1 = Item(id: 1, name: "Angular", full_name: "", owner: Owner(login: "", avatar_url: ""), html_url: "", description: "", fork: false, url: "", homepage: "", size: 1, language: "", license: nil, forks: 1, watchers: 1, score: 1, stargazers_count: 1, watchers_count: 1, forks_count: 1)
        
        let service = GithubServiceSpy(results: [
            Result.failure(AnyError(errorDescription: "1st error")),
            Result.failure(AnyError(errorDescription: "2nd error")),
            Result.success([repositoryItem1])
        ])
        
        let sut = TestableSearchViewController(service: service)
        
        sut.simulateViewWillAppear()
        
        sut.assert(isRendering: [repositoryItem1])
    }

}

private struct AnyError: LocalizedError {
    var errorDescription: String?
}

private class TestableSearchViewController: SearchViewController {
    var presentedVC: UIViewController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedVC = viewControllerToPresent
    }
    
    func errorMessage() -> String? {
        let alert = presentedVC as? UIAlertController
        return alert?.message
    }
}
 
private extension SearchViewController {
    func simulateViewWillAppear() {
        loadViewIfNeeded()
        beginAppearanceTransition(true, animated: false)
    }
    
    func assert(isRendering repositories: [Item]) {
        XCTAssertEqual(numberOfRepositories(), repositories.count)
        
        for (index, repo) in repositories.enumerated() {
            XCTAssertEqual(repositoryName(at: index), repo.name)
        }
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
