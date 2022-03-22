import Resolver

extension Resolver {

    static func registerAccount() {
        registerServices()
    }

    private static func registerServices() {
        register {
            AccountService(networkManager: resolve())
        }
        .implements(AccountServiceProtocol.self)
        .scope(.shared)
    }

}
