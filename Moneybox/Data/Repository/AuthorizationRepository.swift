import Foundation
import RxSwift

final class AuthorizationRepository: AuthorizationRepositoryProtocol {

    private let service: AuthorizationServiceProtocol

    private var authorizationToken: String?

    init(service: AuthorizationServiceProtocol) {
        self.service = service
    }

    func login(_ request: LoginRequest) -> Single<LoginResponse> {
        service.login(request)
            .do(onSuccess: { [weak self] result in
                self?.authorizationToken = result.session.bearerToken
            })
    }

    func getToken() -> String? {
        authorizationToken
    }

}
