import Foundation

struct OneOffPaymentResponse: Decodable {

    let moneybox: Double

    enum CodingKeys: String, CodingKey {
        case moneybox = "Moneybox"
    }

}
