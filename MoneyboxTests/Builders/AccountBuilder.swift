import Foundation

@testable import Moneybox

struct AccountBuilder {

    private static let productDetailsResponse = ProductDetailsResponse(friendlyName: "Stocks & Shares ISA")

    private static let productResponse = ProductResponse(investorProductId: 8043,
                                                         planValue: 31045.13,
                                                         moneybox: 60.00,
                                                         product: productDetailsResponse)

    static let investorProductsResponse = InvestorProductsResponse(totalPlanValue: 43879.930000,
                                                                   productResponses: [productResponse])

    static let oneOffPaymentResponse = OneOffPaymentResponse(moneybox: 130.00)

    static let userAccountItem = UserAccountItem(investorProductId: 8043,
                                                 name: "Stocks & Shares ISA",
                                                 planValue: 31045.13,
                                                 moneybox: 130.00)

}
