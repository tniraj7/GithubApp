import XCTest
@testable import GithubApp

class GithubServiceSpy: GithubService {
    private(set) var loadRepositoriesAPICallCount: Int = 0
    func loadGithubRepositoryData(keyword: String, completion: @escaping ((Result<GithubAPIResponse, Error>) -> Void)) {
        loadRepositoriesAPICallCount += 1
    }
}

class GithubAppTests: XCTestCase {

    func test_viewDidLoad_doesntLoadGithubRepositoryData() {
        
        let service = GithubServiceSpy()
        let sut = SearcViewController(service: service)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(service.loadRepositoriesAPICallCount, 0)
    }
}
