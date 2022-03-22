@testable import Moneybox

extension ProductResponse: Equatable {

    public static func == (lhs: ProductResponse, rhs: ProductResponse) -> Bool {
        lhs.investorProductId == rhs.investorProductId &&
        lhs.planValue == rhs.planValue &&
        lhs.moneybox == rhs.moneybox &&
        lhs.product == rhs.product
    }

}
