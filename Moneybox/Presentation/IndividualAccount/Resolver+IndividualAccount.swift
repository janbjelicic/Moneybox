import Resolver

extension Resolver {

    static func registerIndividualAccount() {
        registerViewModel()
        registerViewController()
    }

    private static func registerViewModel() {
        register { _, dependencies -> IndividualAccountViewModel in
            IndividualAccountViewModel(accountService: resolve(),
                                       dependencies: dependencies())
        }
    }

    private static func registerViewController() {
        register { _, viewModel -> IndividualAccountViewController in
            IndividualAccountViewController.instantiate(viewModel: viewModel())
        }
    }

}
