import Foundation

struct ProductDetailsResponse: Decodable {

    let friendlyName: String

    enum CodingKeys: String, CodingKey {
        case friendlyName = "FriendlyName"
    }

}
