import Resolver
import RxCocoa
import RxSwift
import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!

    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!

    @IBOutlet private weak var loginButton: UIButton!

    // MARK: - Data
    weak var coordinator: AppCoordinator?

    private var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - Init
    static func instantiate(viewModel: LoginViewModel) -> LoginViewController {
        let viewController = Storyboard.Main.instantiate(LoginViewController.self)
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
        title = "Login"

        emailLabel.text = "Email"
        passwordLabel.text = "Password"

        loginButton.setTitle("Login", for: .normal)

        activityIndicatorView.style = .medium
    }

    private func bindInputs() {
        loginButton.rx.tap
            .throttle(.seconds(2),
                      latest: false,
                      scheduler: MainScheduler.instance)
            .map {
                .didTapLogin
            }
            .bind(to: viewModel.input.action)
            .disposed(by: disposeBag)

        emailTextField.rx.text
            .skip(1)
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)

        passwordTextField.rx.text
            .skip(1)
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)
    }

    private func bindOutputs() {
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

        viewModel.output.showUserAccounts
            .asSignal()
            .emit(onNext: showUserAccountsScreen)
            .disposed(by: disposeBag)

        viewModel.output.showError
            .asSignal()
            .emit(onNext: showError)
            .disposed(by: disposeBag)
    }

    private func showUserAccountsScreen() {
        coordinator?.showUserAccountsScreen()
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
