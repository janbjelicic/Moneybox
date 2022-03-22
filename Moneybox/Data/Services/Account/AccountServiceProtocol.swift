import Foundation
import RxSwift

protocol AccountServiceProtocol {

    func getInvestorProducts(_ request: InvestorProductsRequest) -> Single<InvestorProductsResponse>
    func oneOffPayment(_ request: OneOffPaymentRequest) -> Single<OneOffPaymentResponse>

}
