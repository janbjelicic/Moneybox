import Foundation

struct InvestorProductsResponse: Decodable {

    let totalPlanValue: Double
    let productResponses: [ProductResponse]

    enum CodingKeys: String, CodingKey {
        case totalPlanValue = "TotalPlanValue"
        case productResponses = "ProductResponses"
    }

}
