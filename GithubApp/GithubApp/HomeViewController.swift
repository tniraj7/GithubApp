import UIKit
import RxSwift
import RxCocoa
import SafariServices

class HomeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var viewModel = HomeViewModel()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for repositories..."
        searchController.searchBar.barStyle = .default
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barTintColor = .black
        searchController.searchBar.backgroundColor = .clear
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Github Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindTableView()
        didSelectItem()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.cellIdentifier)
    }
    
    private func bindTableView() {
        tableView.dataSource = nil
        viewModel
            .getRepositories(searchController.searchBar.rx.text.orEmpty.asObservable())
            .bind(to: tableView.rx.items) {
                (tableView: UITableView, index: Int, element: Item) in

                let indexPath = IndexPath(item: index, section: 0)

                guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.cellIdentifier, for: indexPath) as? RepositoryCell else {
                    return UITableViewCell()
                }

                cell.setupCell(element)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func didSelectItem() {
        tableView.delegate = nil
        tableView.rx
            .modelSelected(Item.self)
            .compactMap({ URL(string: $0.html_url) })
            .map { SFSafariViewController(url: $0) }
            .subscribe(onNext: { [weak self] safariViewController in
                self?.present(safariViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

