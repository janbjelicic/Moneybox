import Foundation
@testable import Moneybox
import RxSwift

class FakeAuthorizationService: AuthorizationServiceProtocol {

    private let loginResponse: LoginResponse

    init(loginResponse: LoginResponse) {
        self.loginResponse = loginResponse
    }

    func login(_ request: LoginRequest) -> Single<LoginResponse> {
        .just(loginResponse)
    }

}
