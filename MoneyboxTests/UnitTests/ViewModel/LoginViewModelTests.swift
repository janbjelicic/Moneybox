@testable import Moneybox
import RxSwift
import XCTest

class LoginViewModelTests: XCTestCase {

    var sut: LoginViewModel!

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
        let authorizationRepository = FakeAuthorizationRepository(loginResponse: response)

        sut = LoginViewModel(authorizationRepository: authorizationRepository)
    }

    // MARK: - Tests
    func testDidTapLogin() {
        let loginResponse = AuthorizationBuilder.loginResponse
        setupTestData(loginResponse)

        let expectation = XCTestExpectation(description: #function)

        sut.output.showUserAccounts
            .subscribe(onNext: { _ in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.input.email.accept("Email")
        sut.input.password.accept("Password")
        sut.input.action.onNext(.didTapLogin)

        wait(for: [expectation], timeout: 1)
    }

}
