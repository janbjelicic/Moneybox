@testable import Moneybox

import RxSwift
import XCTest

class AuthorizationRepositoryTests: XCTestCase {

    var sut: AuthorizationRepository!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        disposeBag = nil
    }

    // MARK: - Helpers
    private func setupTestData(_ response: LoginResponse) {
        let authorizationService = FakeAuthorizationService(loginResponse: response)

        sut = AuthorizationRepository(service: authorizationService)
    }

    // MARK: - Tests
    func testGetToken() {
        let expectedResponse = AuthorizationBuilder.loginResponse
        setupTestData(expectedResponse)

        let email = "test@gmail.com"
        let password = "Pa33word1234"
        let request = LoginRequest(email: email,
                                   password: password)

        let expectation = XCTestExpectation(description: #function)
        sut.login(request)
            .subscribe(with: self, onSuccess: { owner, _ in
                let token = owner.sut.getToken()
                XCTAssertEqual(token, expectedResponse.session.bearerToken)
                expectation.fulfill()
            }, onFailure: { _, _ in
                XCTFail("testGetToken shouldn't fail.")
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)

    }

}
