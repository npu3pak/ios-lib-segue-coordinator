
import UIKit

// MARK: Utility

public extension SegueCoordinator {

    /**
     Returns top view controller.
    */
    var topController: UIViewController {
        // View controllers are presented from Navigation Controller if it exists
        var controller: UIViewController = rootNavigationController

        while let presented = controller.presentedViewController {
            controller = presented
        }

        if let topNavigationController = controller as? UINavigationController {
            return topNavigationController.viewControllers.last ?? topNavigationController
        }

        return controller
    }

    /**
     Returns navigation controller of top view controller if it exists. Returns nil otherwise.
     */
    var topNavigationController: UINavigationController? {
        return topController === rootNavigationController ? rootNavigationController : topController.navigationController
    }
}
