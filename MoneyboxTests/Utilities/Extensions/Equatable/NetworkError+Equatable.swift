@testable import Moneybox

extension NetworkError: Equatable {

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.generic, .generic):
            return true
        case (.badRequest, .badRequest):
            return true
        case (.unauthorized, .unauthorized):
            return true
        case (let .descriptive(lhsErrorInformation), let .descriptive(rhsErrorInformation)):
            return lhsErrorInformation == rhsErrorInformation

        default:
            return false
        }
    }

}
