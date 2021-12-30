import UIKit

class SearcViewController: UIViewController {
    
    private let service: GithubService
    
    init(service: GithubService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
