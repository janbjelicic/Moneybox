import UIKit

extension UIViewController {

    static var storyboardIdentifier: String {
        self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }

}
