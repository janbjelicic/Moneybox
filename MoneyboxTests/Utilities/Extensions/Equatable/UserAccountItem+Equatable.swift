@testable import Moneybox

extension UserAccountItem: Equatable {

    public static func == (lhs: UserAccountItem, rhs: UserAccountItem) -> Bool {
        lhs.investorProductId == rhs.investorProductId &&
        lhs.name == rhs.name &&
        lhs.planValue == rhs.planValue &&
        lhs.moneybox == rhs.moneybox
    }

}
