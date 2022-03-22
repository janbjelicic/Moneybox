import Resolver

extension Resolver: ResolverRegistering {

    public static func registerAllServices() {
        registerAPI()
        registerAccount()

        registerLogin()
        registerUserAccounts()
        registerIndividualAccount()
    }

}
