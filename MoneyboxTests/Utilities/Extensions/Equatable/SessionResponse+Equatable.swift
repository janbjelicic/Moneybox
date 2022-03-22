@testable import Moneybox

extension SessionResponse: Equatable {

    public static func == (lhs: SessionResponse, rhs: SessionResponse) -> Bool {
        lhs.bearerToken == rhs.bearerToken &&
        lhs.externalSessionId == rhs.externalSessionId &&
        lhs.sessionExternalId == rhs.sessionExternalId &&
        lhs.expiryInSeconds == rhs.expiryInSeconds
    }

}
