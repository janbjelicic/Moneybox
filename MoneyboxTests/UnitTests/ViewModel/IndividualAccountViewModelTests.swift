@testable import Moneybox
import RxSwift
import XCTest

class IndividualAccountViewModelTests: XCTestCase {

    var sut: IndividualAccountViewModel!

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
    private func setupTestData(dependencies: IndividualAccountDependencies,
                               response: OneOffPaymentResponse) {
        let accountService = FakeAccountService(oneOffPaymentResponse: response)

        sut = IndividualAccountViewModel(accountService: accountService,
                                         dependencies: dependencies)
    }

    // MARK: - Tests
    func testInitialState() {
        let userAccountItem = AccountBuilder.userAccountItem
        let dependencies = IndividualAccountDependencies(userAccountItem: userAccountItem)

        let oneOffPaymentResponse = AccountBuilder.oneOffPaymentResponse

        setupTestData(dependencies: dependencies,
                      response: oneOffPaymentResponse)

        sut.output.name
            .subscribe(onNext: { text in
                XCTAssertEqual(text, dependencies.userAccountItem.name)
            })
            .disposed(by: disposeBag)

        sut.output.planValue
            .subscribe(onNext: { text in
                XCTAssertEqual(text, "Plan value: £\(dependencies.userAccountItem.planValue)")
            })
            .disposed(by: disposeBag)

        sut.output.moneybox
            .subscribe(onNext: { text in
                XCTAssertEqual(text, "Moneybox: £\(dependencies.userAccountItem.moneybox)")
            })
            .disposed(by: disposeBag)
    }

    func testDidTapAdd() {
        let userAccountItem = AccountBuilder.userAccountItem
        let dependencies = IndividualAccountDependencies(userAccountItem: userAccountItem)

        let oneOffPaymentResponse = AccountBuilder.oneOffPaymentResponse

        setupTestData(dependencies: dependencies,
                      response: oneOffPaymentResponse)

        let expectation = XCTestExpectation(description: #function)

        sut.output.moneybox
            .subscribe(onNext: { text in
                XCTAssertEqual(text, "Moneybox: £\(oneOffPaymentResponse.moneybox)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.input.action.onNext(.didTapAdd)

        wait(for: [expectation], timeout: 1)
    }

}
