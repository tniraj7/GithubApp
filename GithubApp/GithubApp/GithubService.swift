import Foundation

protocol GithubService {
    func loadGithubRepositoryData(keyword: String, completion: @escaping((Result<[Item]?, Error>) -> Void))
}
