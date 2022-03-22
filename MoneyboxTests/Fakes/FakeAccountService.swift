import Foundation
@testable import Moneybox
import RxSwift

class FakeAccountService: AccountServiceProtocol {

    private let investorProductsResponse: InvestorProductsResponse?
    private let oneOffPaymentResponse: OneOffPaymentResponse?

    init(investorProductsResponse: InvestorProductsResponse? = nil,
         oneOffPaymentResponse: OneOffPaymentResponse? = nil) {
        self.investorProductsResponse = investorProductsResponse
        self.oneOffPaymentResponse = oneOffPaymentResponse
    }

    func getInvestorProducts(_ request: InvestorProductsRequest) -> Single<InvestorProductsResponse> {
        if let investorProductsResponse = investorProductsResponse {
            return .just(investorProductsResponse)
        } else {
            return .error(NetworkError.generic)
        }
    }

    func oneOffPayment(_ request: OneOffPaymentRequest) -> Single<OneOffPaymentResponse> {
        if let oneOffPaymentResponse = oneOffPaymentResponse {
            return .just(oneOffPaymentResponse)
        } else {
            return .error(NetworkError.generic)
        }
    }

}
