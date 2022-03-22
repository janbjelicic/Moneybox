import Foundation

@testable import Moneybox

struct AuthorizationBuilder {

    private static let sessionResponse = SessionResponse(bearerToken: "uJplU/kiHG9ZJPo5Hl4ABYNeCkC8rUCIJLTt6tVjAvI=",
                                                         externalSessionId: "3980de32-7102-4798-b240-dd7080eda478",
                                                         sessionExternalId: "3980de32-7102-4798-b240-dd7080eda478",
                                                         expiryInSeconds: 0)

    static let loginResponse = LoginResponse(session: sessionResponse)

}
