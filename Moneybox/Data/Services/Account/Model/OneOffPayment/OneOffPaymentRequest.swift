import Foundation

struct OneOffPaymentRequest: Encodable {

    let amount: Int
    let investorProductId: Int

    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case investorProductId = "InvestorProductId"
    }

}

extension OneOffPaymentRequest: NetworkRequest {

    var path: String {
        "oneoffpayments"
    }

    var method: HttpVerb {
        .post
    }

    var parameters: [String: Any]? {
        ["Amount": amount,
         "InvestorProductId": investorProductId]
    }

    var requiresAuthentication: Bool {
        true
    }

}
