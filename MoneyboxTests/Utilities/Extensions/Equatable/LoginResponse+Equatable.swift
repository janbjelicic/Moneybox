@testable import Moneybox

extension LoginResponse: Equatable {

    public static func == (lhs: LoginResponse, rhs: LoginResponse) -> Bool {
        lhs.session == rhs.session
    }

}
