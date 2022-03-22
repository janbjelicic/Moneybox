@testable import Moneybox

extension IndividualAccountDependencies: Equatable {

    public static func == (lhs: IndividualAccountDependencies, rhs: IndividualAccountDependencies) -> Bool {
        lhs.userAccountItem == rhs.userAccountItem
    }

}
