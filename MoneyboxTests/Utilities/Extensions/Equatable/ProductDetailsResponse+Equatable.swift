@testable import Moneybox

extension ProductDetailsResponse: Equatable {

    public static func == (lhs: ProductDetailsResponse, rhs: ProductDetailsResponse) -> Bool {
        lhs.friendlyName == rhs.friendlyName
    }

}
