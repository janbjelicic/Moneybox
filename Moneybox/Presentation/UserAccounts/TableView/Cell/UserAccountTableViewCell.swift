import UIKit

class UserAccountTableViewCell: UITableViewCell {

    static var reuseIdentifier: String = "UserAccountTableViewCell"

    // MARK: - Outlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var planValueLabel: UILabel!
    @IBOutlet private weak var moneyboxLabel: UILabel!

    // MARK: - Public functions
    func configure(with item: UserAccountItem) {
        nameLabel.text = item.name
        planValueLabel.text = "Plan value: £\(item.planValue)"
        moneyboxLabel.text = "Moneybox: £\(item.moneybox)"
    }

}
