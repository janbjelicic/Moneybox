@testable import Moneybox

import RxSwift
import XCTest

class AccountServiceTests: XCTestCase {

    private enum Endpoint {
        static let endpointInvestorProducts = "investorproducts"
        static let endpointOneOffPayments = "oneoffpayments"
    }

    var sut: AccountService!
    var networkManager: FakeNetworkManager!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        networkManager = nil
        disposeBag = nil
    }

    // MARK: - Helpers
    private func setupTestData(responseJSON: String? = nil,
                               error: Error? = nil) {
        networkManager = FakeNetworkManager(responseJSON: responseJSON,
                                            error: error)

        sut = AccountService(networkManager: networkManager)
    }

    // MARK: - Tests
    func testInvestorProductsRequestDetails() {
        let responseJSON = TestUtilities.loadTextFile("investorproducts.json")
        setupTestData(responseJSON: responseJSON)

        let expectedResponse = AccountBuilder.investorProductsResponse

        let request = InvestorProductsRequest()

        let expectation = XCTestExpectation(description: #function)
        sut.getInvestorProducts(request)
            .subscribe(onSuccess: { response in
                XCTAssertEqual(expectedResponse, response)
                expectation.fulfill()
            }, onFailure: { _ in
                XCTFail("testInvestorProductsRequestDetails shouldn't fail.")
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)

        let expectedMethod = HttpVerb.get
        let expectedPath = Endpoint.endpointInvestorProducts

        XCTAssertEqual(expectedMethod, networkManager.method)
        XCTAssertEqual(expectedPath, networkManager.path)
        XCTAssertTrue(networkManager.requiresAuthentication)
    }

    func testOneOffPaymentsRequestDetails() {
        let responseJSON = TestUtilities.loadTextFile("oneoffpayments.json")
        setupTestData(responseJSON: responseJSON)

        let expectedResponse = AccountBuilder.oneOffPaymentResponse

        let amount = 10
        let investorProductId = 8043
        let request = OneOffPaymentRequest(amount: amount,
                                           investorProductId: investorProductId)

        let expectation = XCTestExpectation(description: #function)
        sut.oneOffPayment(request)
            .subscribe(onSuccess: { response in
                XCTAssertEqual(expectedResponse, response)
                expectation.fulfill()
            }, onFailure: { _ in
                XCTFail("testOneOffPayments shouldn't fail.")
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)

        let expectedMethod = HttpVerb.post
        let expectedPath = Endpoint.endpointOneOffPayments
        let expectedParameters: [String: Any] = ["Amount": amount,
                                                 "InvestorProductId": investorProductId]

        XCTAssertEqual(expectedMethod, networkManager.method)
        XCTAssertEqual(expectedPath, networkManager.path)
        XCTAssertTrue(networkManager.requiresAuthentication)

        XCTAssertEqual(expectedParameters["Amount"] as! Int, networkManager.parameters!["Amount"] as! Int)
        XCTAssertEqual(expectedParameters["InvestorProductId"] as! Int, networkManager.parameters!["InvestorProductId"] as! Int)
    }

    func testOneOffPaymentsError() {
        let expectedError = NetworkError.descriptive(information: ErrorBuilder.errorInformation)
        setupTestData(error: expectedError)

        let amount = 10
        let investorProductId = 8043
        let request = OneOffPaymentRequest(amount: amount,
                                           investorProductId: investorProductId)

        let expectation = XCTestExpectation(description: #function)
        sut.oneOffPayment(request)
            .subscribe(onSuccess: { _ in
                XCTFail("testOneOffPayments shouldn't succeed.")
            }, onFailure: { error in
                XCTAssertEqual(expectedError, error as! NetworkError)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)

        let expectedMethod = HttpVerb.post
        let expectedPath = Endpoint.endpointOneOffPayments
        let expectedParameters: [String: Any] = ["Amount": amount,
                                                 "InvestorProductId": investorProductId]

        XCTAssertEqual(expectedMethod, networkManager.method)
        XCTAssertEqual(expectedPath, networkManager.path)
        XCTAssertTrue(networkManager.requiresAuthentication)

        XCTAssertEqual(expectedParameters["Amount"] as! Int, networkManager.parameters!["Amount"] as! Int)
        XCTAssertEqual(expectedParameters["InvestorProductId"] as! Int, networkManager.parameters!["InvestorProductId"] as! Int)
    }

}
