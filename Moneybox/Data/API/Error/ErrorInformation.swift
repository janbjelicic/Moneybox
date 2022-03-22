import Foundation

struct ErrorInformation: Decodable {

    let name: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case message = "Message"
    }

}
