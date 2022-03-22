import Resolver
import UIKit

class AppCoordinator: Coordinator {

    private let window: UIWindow
    var childrenCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }

    func start() {
        let loginViewController = Resolver.resolve(LoginViewController.self)
        loginViewController.coordinator = self

        navigationController.pushViewController(loginViewController, animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func showUserAccountsScreen() {
        let userAccountsViewController = Resolver.resolve(UserAccountsViewController.self)
        userAccountsViewController.coordinator = self

        navigationController.pushViewController(userAccountsViewController, animated: true)
    }

    func showIndividualAccountScreen(_ dependencies: IndividualAccountDependencies) {
        let individualAccountViewModel = Resolver.resolve(IndividualAccountViewModel.self, args: dependencies)
        let individualAccountViewController = Resolver.resolve(IndividualAccountViewController.self, args: individualAccountViewModel)
        individualAccountViewController.coordinator = self

        navigationController.pushViewController(individualAccountViewController, animated: true)
    }

    func showLoginScreen() {
        navigationController.popToRootViewController(animated: true)
    }

}
