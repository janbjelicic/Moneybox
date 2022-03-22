@testable import Moneybox
import RxSwift
import XCTest

class UserAccountsViewModelTests: XCTestCase {

    var sut: UserAccountsViewModel!

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
    private func setupTestData(_ response: InvestorProductsResponse) {
        let accountService = FakeAccountService(investorProductsResponse: response)

        sut = UserAccountsViewModel(userAccountItemMapper: UserAccountItemMapper(),
                                    accountService: accountService)
    }

    // MARK: - Tests
    func testDidTapLogin() {
        let investorProdcutsResponse = AccountBuilder.investorProductsResponse
        setupTestData(investorProdcutsResponse)

        let expectation = XCTestExpectation(description: #function)

//        sut.output.showUserAccounts
//            .subscribe(onNext: { _ in
//                expectation.fulfill()
//            })
//            .disposed(by: disposeBag)
//
//        sut.input.email.accept("Email")
//        sut.input.password.accept("Password")
//        sut.input.action.onNext(.didTapLogin)

        wait(for: [expectation], timeout: 1)
    }

}
