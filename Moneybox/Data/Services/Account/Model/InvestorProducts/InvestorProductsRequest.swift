import Foundation

struct InvestorProductsRequest: Encodable {

}

extension InvestorProductsRequest: NetworkRequest {

    var path: String {
        "investorproducts"
    }

    var method: HttpVerb {
        .get
    }

    var parameters: [String: Any]? {
        nil
    }

    var requiresAuthentication: Bool {
        true
    }

}
