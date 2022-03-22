import Foundation
import RxSwift

final class AuthorizationService: AuthorizationServiceProtocol {

    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func login(_ request: LoginRequest) -> Single<LoginResponse> {
        networkManager.request(request: request)
    }

}
