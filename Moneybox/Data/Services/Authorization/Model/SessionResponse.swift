import Foundation

struct SessionResponse: Decodable {

    let bearerToken: String
    let externalSessionId: String
    let sessionExternalId: String
    let expiryInSeconds: Int

    enum CodingKeys: String, CodingKey {
        case bearerToken = "BearerToken"
        case externalSessionId = "ExternalSessionId"
        case sessionExternalId = "SessionExternalId"
        case expiryInSeconds = "ExpiryInSeconds"
    }

}
