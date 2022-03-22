import UIKit

enum Storyboard: String {

    case Main

    public func instantiate<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        guard let viewController = UIStoryboard(name: self.rawValue, bundle: nil)
                .instantiateViewController(withIdentifier: VC.storyboardIdentifier) as? VC
            else { fatalError("Couldn't instantiate \(VC.storyboardIdentifier) from \(self.rawValue)") }

        return viewController
    }

}
