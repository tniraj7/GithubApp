import UIKit
import Combine
import SafariServices

enum Section {
    case all
}

class DiffVC: UIViewController {
    
    private var viewModel: ViewModel
    private var disposable = Set<AnyCancellable>()
    
    private lazy var tableV: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private lazy var dataSource = configureDataSource()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.barStyle = .default
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barTintColor = .black
        searchController.searchBar.backgroundColor = .clear
        return searchController
    }()
    
    init?(viewModel: ViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableV)
        tableV.frame = self.view.frame
        tableV.dataSource = dataSource
        tableV.delegate = self
        tableV.rowHeight = 100
        tableV.register(CustomCell.self,forCellReuseIdentifier: CustomCell.identifier)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeSearchBarText()
        observeViewModelData()
    }
    
    private func observeSearchBarText() {
        searchController.searchBar
            .searchTextField
            .textPublisher
            .sink { [weak self] keyword in
                self?.viewModel.keyword.send(keyword)
            }.store(in: &disposable)
    }
    
    private func observeViewModelData() {
        viewModel.repositories.sink { [weak self] _ in
            self?.applySnapshot()
        }.store(in: &disposable)
        
        viewModel.error.sink { [weak self] error in
            if let error = error {
                self?.showAlert(alertTitle: "Error", alertBody: error, buttonTitle: "OK")
            }
        }.store(in: &disposable)
        
        viewModel.isLoading.sink { [weak self] isLoading in
            self?.applySnapshot()
        }.store(in: &disposable)
    }
    
    private func configureDataSource() -> UITableViewDiffableDataSource<Section, Item> {
        let dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableV) {
            (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier) as! CustomCell
            cell.configureCell(item: item)
            return cell
        }
        dataSource.defaultRowAnimation = .fade
        return dataSource
    }
    
    private func applySnapshot(animateDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.all])
        snapshot.appendItems(viewModel.repositories.value)
        dataSource.apply(snapshot, animatingDifferences: animateDifferences)
    }
}
// MARK: - TableView Delegate

extension DiffVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = viewModel.repositories.value[indexPath.row].owner.htmlURL
        let vc = SFSafariViewController(url: URL(string: url)!)
        vc.modalPresentationStyle = .pageSheet
        vc.delegate = self
        self.navigationController?.present(vc, animated: true)
    }
}

extension DiffVC : SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
    }
}
