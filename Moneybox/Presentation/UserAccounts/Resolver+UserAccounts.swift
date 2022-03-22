import Resolver

extension Resolver {

    static func registerUserAccounts() {
        registerMappers()
        registerViewModel()
        registerViewController()
    }

    private static func registerMappers() {
        register {
            UserAccountItemMapper()
        }
        .implements(UserAccountItemMapperProtocol.self)
        .scope(.shared)
    }

    private static func registerViewModel() {
        register {
            UserAccountsViewModel(userAccountItemMapper: resolve(),
                                  accountService: resolve())
        }
    }

    private static func registerViewController() {
        register {
            UserAccountsViewController.instantiate(viewModel: resolve())
        }
    }

}
