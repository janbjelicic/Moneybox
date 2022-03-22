import RxCocoa
import RxSwift
import UIKit

class IndividualAccountViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var planValueLabel: UILabel!
    @IBOutlet private weak var moneyboxLabel: UILabel!

    @IBOutlet private weak var addButton: PrimaryButton!

    // MARK: - Data
    weak var coordinator: AppCoordinator?

    private var viewModel: IndividualAccountViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - Init
    static func instantiate(viewModel: IndividualAccountViewModel) -> IndividualAccountViewController {
        let viewController = Storyboard.Main.instantiate(IndividualAccountViewController.self)
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

    // MARK: - UI
    private func setupUI() {
        title = "Individual Account"

        addButton.setTitle("Add £10", for: .normal)
    }

    private func bindInputs() {
        addButton.rx.tap
            .throttle(.seconds(2),
                      latest: false,
                      scheduler: MainScheduler.instance)
            .map {
                .didTapAdd
            }
            .bind(to: viewModel.input.action)
            .disposed(by: disposeBag)
    }

    private func bindOutputs() {
        viewModel.output.name
            .asDriver()
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.planValue
            .asDriver()
            .drive(planValueLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.moneybox
            .asDriver()
            .drive(moneyboxLabel.rx.text)
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

        viewModel.output.showLoginScreen
            .asSignal()
            .emit(onNext: showLoginScreen)
            .disposed(by: disposeBag)
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
