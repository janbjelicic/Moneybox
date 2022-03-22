@testable import Moneybox

extension InvestorProductsResponse: Equatable {

    public static func == (lhs: InvestorProductsResponse, rhs: InvestorProductsResponse) -> Bool {
        lhs.totalPlanValue == rhs.totalPlanValue &&
        lhs.productResponses == rhs.productResponses
    }

}
