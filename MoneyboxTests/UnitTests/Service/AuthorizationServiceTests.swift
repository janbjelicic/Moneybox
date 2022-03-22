@testable import Moneybox

import RxSwift
import XCTest

class AuthorizationServiceTests: XCTestCase {

    private enum Endpoint {
        static let endpointLogin = "users/login"
    }

    var sut: AuthorizationService!
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

        sut = AuthorizationService(networkManager: networkManager)
    }

    // MARK: - Tests
    func testLoginRequestDetails() {
        let responseJSON = TestUtilities.loadTextFile("users-login.json")
        setupTestData(responseJSON: responseJSON)

        let expectedResponse = AuthorizationBuilder.loginResponse

        let email = "test@gmail.com"
        let password = "Pa33word1234"
        let request = LoginRequest(email: email,
                                   password: password)

        let expectation = XCTestExpectation(description: #function)
        sut.login(request)
            .subscribe(onSuccess: { response in
                XCTAssertEqual(expectedResponse, response)
                expectation.fulfill()
            }, onFailure: { _ in
                XCTFail("testLoginRequestDetails shouldn't fail.")
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)

        let expectedMethod = HttpVerb.post
        let expectedPath = Endpoint.endpointLogin
        let expectedParameters: [String: Any] = ["Email": email,
                                                 "Password": password]

        XCTAssertEqual(expectedMethod, networkManager.method)
        XCTAssertEqual(expectedPath, networkManager.path)
        XCTAssertFalse(networkManager.requiresAuthentication)

        XCTAssertEqual(expectedParameters["Email"] as! String, networkManager.parameters!["Email"] as! String)
        XCTAssertEqual(expectedParameters["Password"] as! String, networkManager.parameters!["Password"] as! String)
    }

    func testLoginError() {
        let expectedError = NetworkError.generic
        setupTestData(error: expectedError)

        let email = "test@gmail.com"
        let password = "Pa33word1234"
        let request = LoginRequest(email: email,
                                   password: password)

        let expectation = XCTestExpectation(description: #function)
        sut.login(request)
            .subscribe(onSuccess: { _ in
                XCTFail("testLoginError shouldn't succeed.")
            }, onFailure: { error in
                XCTAssertEqual(expectedError, error as! NetworkError)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)

        let expectedMethod = HttpVerb.post
        let expectedPath = Endpoint.endpointLogin
        let expectedParameters: [String: Any] = ["Email": email,
                                                 "Password": password]

        XCTAssertEqual(expectedMethod, networkManager.method)
        XCTAssertEqual(expectedPath, networkManager.path)
        XCTAssertFalse(networkManager.requiresAuthentication)

        XCTAssertEqual(expectedParameters["Email"] as! String, networkManager.parameters!["Email"] as! String)
        XCTAssertEqual(expectedParameters["Password"] as! String, networkManager.parameters!["Password"] as! String)
    }

}
