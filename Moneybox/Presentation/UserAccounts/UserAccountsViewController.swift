import RxCocoa
import RxSwift
import UIKit

class UserAccountsViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    @IBOutlet private weak var greetingLabel: UILabel!
    @IBOutlet private weak var totalPlanValueLabel: UILabel!

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Data
    weak var coordinator: AppCoordinator?

    private var viewModel: UserAccountsViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - Init
    static func instantiate(viewModel: UserAccountsViewModel) -> UserAccountsViewController {
        let viewController = Storyboard.Main.instantiate(UserAccountsViewController.self)
        viewController.viewModel = viewModel
        return viewController
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindInputs()
        bindOutputs()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.action.onNext(.viewWillAppear)
    }

    // MARK: - UI
    private func setupUI() {
        title = "User Accounts"
        setupPullToRefresh()
    }

    private func setupPullToRefresh() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
    }

    @objc private func refreshTriggered() {
        viewModel.input.action.onNext(.reloadInvestorProducts)
    }

    private func bindInputs() {
        tableView.rx.modelSelected(UserAccountItem.self)
            .map { .selectedItem($0) }
            .bind(to: viewModel.input.action)
            .disposed(by: disposeBag)
    }

    private func bindOutputs() {
        viewModel.output.greeting
            .asDriver()
            .drive(greetingLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.totalPlanValue
            .asDriver()
            .drive(totalPlanValueLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.items
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: UserAccountTableViewCell.reuseIdentifier,
                                      cellType: UserAccountTableViewCell.self)) { _, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)

        viewModel.output.isTableViewHidden
            .asDriver()
            .drive(tableView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.output.hideTableViewRefreshControl
            .asSignal()
            .emit(with: self, onNext: { owner, _ in
                owner.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)

        viewModel.output.isLoaderAnimating
            .asDriver()
            .drive(with: self, onNext: { owner, isAnimating in
                owner.activityIndicatorView.isHidden = !isAnimating
                if isAnimating {
                    owner.activityIndicatorView.startAnimating()
                } else {
                    owner.activityIndicatorView.stopAnimating()
                }
            })
            .disposed(by: disposeBag)

        viewModel.output.showError
            .asSignal()
            .emit(onNext: showError)
            .disposed(by: disposeBag)

        viewModel.output.showIndividualAccountScreen
            .asSignal()
            .emit(onNext: showIndividualAccountScreen)
            .disposed(by: disposeBag)

        viewModel.output.showLoginScreen
            .asSignal()
            .emit(onNext: showLoginScreen)
            .disposed(by: disposeBag)
    }

    private func showIndividualAccountScreen(_ dependencies: IndividualAccountDependencies) {
        coordinator?.showIndividualAccountScreen(dependencies)
    }

    private func showLoginScreen() {
        coordinator?.showLoginScreen()
    }

    private func showError(_ information: ErrorInformation) {
        let alert = UIAlertController(title: information.name,
                                      message: information.message,
                                      preferredStyle: .alert)

        let closeAction = UIAlertAction(title: "Close",
                                        style: .default)

        alert.addAction(closeAction)
        present(alert, animated: false)
    }

}

extension UserAccountsViewController: UITableViewDelegate {

}
