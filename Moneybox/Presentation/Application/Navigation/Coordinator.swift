import UIKit

protocol Coordinator: AnyObject {

    var childrenCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()

}
