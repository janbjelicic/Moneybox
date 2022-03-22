import Resolver

extension Resolver {

    static func registerLogin() {
        registerServices()
        registerRepositories()
        registerViewModel()
        registerViewController()
    }

    private static func registerServices() {
        register {
            AuthorizationService(networkManager: resolve())
        }
        .implements(AuthorizationServiceProtocol.self)
        .scope(.shared)
    }

    private static func registerRepositories() {
        register {
            AuthorizationRepository(service: resolve())
        }
        .implements(AuthorizationRepositoryProtocol.self)
        .scope(.shared)
    }

    private static func registerViewModel() {
        register {
            LoginViewModel(authorizationRepository: resolve())
        }
    }

    private static func registerViewController() {
        register {
            LoginViewController.instantiate(viewModel: resolve())
        }
    }

}
