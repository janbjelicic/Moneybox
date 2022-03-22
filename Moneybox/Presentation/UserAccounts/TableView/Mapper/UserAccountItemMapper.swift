import Foundation

class UserAccountItemMapper: UserAccountItemMapperProtocol {

    func callAsFunction(_ data: InvestorProductsResponse) -> [UserAccountItem] {
        var items: [UserAccountItem] = []
        for product in data.productResponses {
            items.append(UserAccountItem(investorProductId: product.investorProductId,
                                         name: product.product.friendlyName,
                                         planValue: product.planValue,
                                         moneybox: product.moneybox))
        }

        return items
    }

}
