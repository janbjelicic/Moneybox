import Foundation

struct ProductResponse: Decodable {

    let investorProductId: Int
    let planValue: Double
    let moneybox: Double
    let product: ProductDetailsResponse

    enum CodingKeys: String, CodingKey {
        case investorProductId = "Id"
        case planValue = "PlanValue"
        case moneybox = "Moneybox"
        case product = "Product"
    }

}
