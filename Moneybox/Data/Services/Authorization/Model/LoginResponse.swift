import Foundation

struct LoginResponse: Decodable {

    let session: SessionResponse

    enum CodingKeys: String, CodingKey {
        case session = "Session"
    }

}
