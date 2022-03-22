import Foundation
import RxCocoa
import RxSwift

class UserAccountsViewModel {

    enum Action {
        case viewWillAppear
        case selectedItem(UserAccountItem)
    }

    struct Input {
        let action = PublishSubject<Action>()
    }

    struct Output {
        let greeting = BehaviorRelay<String?>(value: nil)
        let totalPlanValue = BehaviorRelay<String?>(value: nil)
        let items = BehaviorRelay<[UserAccountItem]>(value: [])
        let isLoaderAnimating = BehaviorRelay<Bool>(value: false)
        let isTableViewHidden = BehaviorRelay<Bool>(value: true)

        let showError = PublishRelay<ErrorInformation>()
        let showIndividualAccountScreen = PublishRelay<IndividualAccountDependencies>()
        let showLoginScreen = PublishRelay<Void>()
    }

    // MARK: - Public properties
    let input = Input()
    let output = Output()

    // MARK: - Private properties
    private let userAccountItemMapper: UserAccountItemMapperProtocol
    private let accountService: AccountServiceProtocol

    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(userAccountItemMapper: UserAccountItemMapperProtocol,
         accountService: AccountServiceProtocol) {
        self.userAccountItemMapper = userAccountItemMapper
        self.accountService = accountService

        bindInputs()
    }

    private func bindInputs() {
        input.action
            .subscribe(with: self, onNext: { owner, action in
                switch action {
                case .viewWillAppear:
                    owner.handleViewWillAppear()
                case .selectedItem(let item):
                    owner.handleSelectedItem(item)
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Actions
    private func handleViewWillAppear() {
        let request = InvestorProductsRequest()

        output.isLoaderAnimating.accept(true)
        output.isTableViewHidden.accept(true)

        accountService.getInvestorProducts(request)
            .subscribe(with: self, onSuccess: { owner, investorProducts in
                owner.handleUserAccountsHeader(investorProducts)

                let items = owner.userAccountItemMapper(investorProducts)
                owner.output.items.accept(items)

                owner.output.isLoaderAnimating.accept(false)
                owner.output.isTableViewHidden.accept(false)
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

    private func handleUserAccountsHeader(_ response: InvestorProductsResponse) {
        output.greeting.accept("Hello Jan!")
        output.totalPlanValue.accept("Total plan value: £\(response.totalPlanValue)")
    }

    private func handleSelectedItem(_ item: UserAccountItem) {
        let dependencies = IndividualAccountDependencies(userAccountItem: item)

        output.showIndividualAccountScreen.accept(dependencies)
    }

    private func handleError(_ errorInformation: ErrorInformation) {
        output.isLoaderAnimating.accept(false)
        output.isTableViewHidden.accept(true)
        output.showError.accept(errorInformation)
    }

}
