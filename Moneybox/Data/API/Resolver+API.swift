import Resolver

extension Resolver {

    static func registerAPI() {
        registerManagers()
    }

    private static func registerManagers() {
        register {
            NetworkManager()
        }
        .implements(NetworkManagerProtocol.self)
        .scope(.shared)
    }

}
