import UIKit

class SearchViewController: UITableViewController {
    
    private let service: GithubService
    private var repositories: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(service: GithubService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        service.loadGithubRepositoryData(keyword: "") { result in
            switch result {
                case let .success(repositories):
                    if let repositories = repositories {
                        self.repositories = repositories
                    }
                case let .failure(error):
                    self.service.loadGithubRepositoryData(keyword: "") { result in
                        switch result {
                            case .success: break
                            case .failure:
                                self.service.loadGithubRepositoryData(keyword: "") { result in
                                    switch result {
                                        case .success: break
                                        case let .failure(error):
                                        self.show(error)
                                    }
                                }
                        }
                    }
                    
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let repositoryItem = repositories[indexPath.row]
        cell.textLabel?.text = repositoryItem.name
        return cell
    }
}

extension UIViewController {
    func show(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
