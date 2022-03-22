@testable import Moneybox

extension OneOffPaymentResponse: Equatable {

    public static func == (lhs: OneOffPaymentResponse, rhs: OneOffPaymentResponse) -> Bool {
        lhs.moneybox == rhs.moneybox
    }

}
