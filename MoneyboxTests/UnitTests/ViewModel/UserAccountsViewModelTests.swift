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
    private func setupTestData(mapper: UserAccountItemMapper,
                               response: InvestorProductsResponse) {
        let accountService = FakeAccountService(investorProductsResponse: response)

        sut = UserAccountsViewModel(userAccountItemMapper: mapper,
                                    accountService: accountService)
    }

    // MARK: - Tests
    func testViewWillAppear() {
        let mapper = UserAccountItemMapper()
        let investorProdcutsResponse = AccountBuilder.investorProductsResponse
        setupTestData(mapper: mapper,
                      response: investorProdcutsResponse)

        let mappedItems = mapper(investorProdcutsResponse)

        let expectation = XCTestExpectation(description: #function)
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 3

        sut.output.greeting
            .skip(1)
            .subscribe(onNext: { text in
                XCTAssertEqual(text, "Hello Jan!")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.output.totalPlanValue
            .skip(1)
            .subscribe(onNext: { text in
                XCTAssertEqual(text, "Total plan value: £\(investorProdcutsResponse.totalPlanValue)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.output.items
            .skip(1)
            .subscribe(onNext: { items in
                XCTAssertEqual(items, mappedItems)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.input.action.onNext(.viewWillAppear)

        wait(for: [expectation], timeout: 1)
    }

    // MARK: - Tests
    func testSelectedItem() {
        let mapper = UserAccountItemMapper()
        let investorProdcutsResponse = AccountBuilder.investorProductsResponse
        setupTestData(mapper: mapper,
                      response: investorProdcutsResponse)

        let mappedItems = mapper(investorProdcutsResponse)
        let expectedMapItem = mappedItems[0]

        let expectation = XCTestExpectation(description: #function)
        let expectedDependencies = IndividualAccountDependencies(userAccountItem: expectedMapItem)

        sut.output.showIndividualAccountScreen
            .subscribe(onNext: { dependecies in
                XCTAssertEqual(dependecies, expectedDependencies)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.input.action.onNext(.selectedItem(expectedMapItem))

        wait(for: [expectation], timeout: 2)
    }

}
