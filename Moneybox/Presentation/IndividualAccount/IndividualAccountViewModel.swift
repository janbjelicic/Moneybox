import Foundation
import RxCocoa
import RxSwift

class IndividualAccountViewModel {

    enum Action {
        case didTapAdd
    }

    struct Input {
        let action = PublishSubject<Action>()
    }

    struct Output {
        let name = BehaviorRelay<String?>(value: nil)
        let planValue = BehaviorRelay<String?>(value: nil)
        let moneybox = BehaviorRelay<String?>(value: nil)
        let isLoaderAnimating = BehaviorRelay<Bool>(value: false)

        let showError = PublishRelay<ErrorInformation>()
        let showLoginScreen = PublishRelay<Void>()
    }

    // MARK: - Public properties
    let input = Input()
    let output = Output()

    // MARK: - Private properties
    private let dependencies: IndividualAccountDependencies
    private let accountService: AccountServiceProtocol

    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(accountService: AccountServiceProtocol,
         dependencies: IndividualAccountDependencies) {
        self.accountService = accountService
        self.dependencies = dependencies

        bindInputs()
        bindOutputs()
    }

    private func bindInputs() {
        input.action
            .subscribe(with: self, onNext: { owner, action in
                switch action {
                case .didTapAdd:
                    owner.handleDidTapAdd()
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindOutputs() {
        output.name.accept(dependencies.userAccountItem.name)
        output.planValue.accept("Plan value: £\(dependencies.userAccountItem.planValue)")
        output.moneybox.accept("Moneybox: £\(dependencies.userAccountItem.moneybox)")
    }

    // MARK: - Actions
    private func handleDidTapAdd() {
        let request = OneOffPaymentRequest(amount: 10,
                                           investorProductId: dependencies.userAccountItem.investorProductId)

        output.isLoaderAnimating.accept(true)
        accountService.oneOffPayment(request)
            .subscribe(with: self, onSuccess: { owner, result in
                owner.output.isLoaderAnimating.accept(false)
                owner.output.moneybox.accept("Moneybox: £\(result.moneybox)")
            }, onFailure: { owner, error in
                let errorInformation = ErrorInformation(name: "Error",
                                                        message: "Something went wrong, please try again.")

                guard let networkError = error as? NetworkError else {
                    owner.handleError(errorInformation)
                    return
                }

                switch networkError {
                case .unauthorized:
                    owner.output.showLoginScreen.accept(())
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
