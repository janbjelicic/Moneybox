import Foundation

protocol UserAccountItemMapperProtocol {

    func callAsFunction(_ data: InvestorProductsResponse) -> [UserAccountItem]

}
