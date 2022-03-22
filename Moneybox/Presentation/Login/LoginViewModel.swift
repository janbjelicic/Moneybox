import Foundation
import RxCocoa
import RxSwift

class LoginViewModel {

    enum Action {
        case didTapLogin
    }

    struct Input {
        let action = PublishSubject<Action>()
        let email = BehaviorRelay<String?>(value: "test+ios@moneyboxapp.com")
        let password = BehaviorRelay<String?>(value: "P455word12")
    }

    struct Output {
        let email = BehaviorRelay<String?>(value: "test+ios@moneyboxapp.com")
        let password = BehaviorRelay<String?>(value: "P455word12")
        let isLoaderAnimating = BehaviorRelay<Bool>(value: false)

        let showError = PublishRelay<ErrorInformation>()
        let showUserAccounts = PublishRelay<Void>()
    }

    // MARK: - Public properties
    let input = Input()
    let output = Output()

    // MARK: - Private properties
    private let authorizationRepository: AuthorizationRepositoryProtocol

    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(authorizationRepository: AuthorizationRepositoryProtocol) {
        self.authorizationRepository = authorizationRepository

        bindInputs()
    }

    private func bindInputs() {
        input.action
            .subscribe(with: self, onNext: { owner, action in
                switch action {
                case .didTapLogin:
                    owner.handleDidTapLogin()
                }
            })
            .disposed(by: disposeBag)

        input.email
            .bind(to: output.email)
            .disposed(by: disposeBag)

        input.password
            .bind(to: output.password)
            .disposed(by: disposeBag)
    }

    // MARK: - Actions
    private func handleDidTapLogin() {
        // Validation error implementation possible.
        guard let email = output.email.value,
              let password = output.password.value else { return }

        let request = LoginRequest(email: email,
                                   password: password)

        output.isLoaderAnimating.accept(true)
        authorizationRepository.login(request)
            .subscribe(with: self, onSuccess: { owner, _ in
                owner.output.isLoaderAnimating.accept(false)
                owner.output.showUserAccounts.accept(())
            }, onFailure: { owner, error in
                let errorInformation = ErrorInformation(name: "Error",
                                                        message: "Please check if you have entered your credentials correctly.")

                guard let networkError = error as? NetworkError else {
                    owner.handleError(errorInformation)
                    return
                }

                switch networkError {
                case .descriptive(let information):
                    owner.handleError(information)
                default:
                    owner.handleError(errorInformation)
                }
            })
            .disposed(by: disposeBag)
    }

    private func handleError(_ errorInformation: ErrorInformation) {
        output.isLoaderAnimating.accept(false)
        output.showError.accept(errorInformation)
    }

}
