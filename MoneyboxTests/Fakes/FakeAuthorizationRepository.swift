import Foundation
@testable import Moneybox
import RxSwift

class FakeAuthorizationRepository: AuthorizationRepositoryProtocol {

    private let loginResponse: LoginResponse

    init(loginResponse: LoginResponse) {
        self.loginResponse = loginResponse
    }

    func login(_ request: LoginRequest) -> Single<LoginResponse> {
        .just(loginResponse)
    }

    func getToken() -> String? {
        loginResponse.session.bearerToken
    }

}
