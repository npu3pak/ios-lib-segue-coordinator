
import UIKit

public extension SegueCoordinator {

    var currentController: UIViewController {
        // View controllers are presented from Navigation Controller if it exists
        var controller: UIViewController = rootNavigationController

        while let presented = controller.presentedViewController {
            controller = presented
        }

        if let topNavigationController = controller as? UINavigationController {
            return topNavigationController.viewControllers.last ?? topNavigationController
        } else {
            return controller
        }
    }

    var currentNavigationController: UINavigationController {
        var navigationController = rootNavigationController
        var controller: UIViewController = rootNavigationController

        while let presented = controller.presentedViewController {
            if presented is UINavigationController {
                navigationController = presented as! UINavigationController
            }
            controller = presented
        }
        return navigationController
    }
}
