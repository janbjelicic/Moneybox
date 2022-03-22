import Foundation
import RxSwift

final class AccountService: AccountServiceProtocol {

    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func getInvestorProducts(_ request: InvestorProductsRequest) -> Single<InvestorProductsResponse> {
        networkManager.request(request: request)
    }

    func oneOffPayment(_ request: OneOffPaymentRequest) -> Single<OneOffPaymentResponse> {
        networkManager.request(request: request)
    }

}
