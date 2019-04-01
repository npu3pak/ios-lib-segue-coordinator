
import UIKit

public extension SegueCoordinator {

    func unwindToFirst<T: UIViewController>(type: T.Type, animated: Bool = true) {
        unwindToFirst(animated: animated, where: {$0 is T})
    }

    func unwindToLast<T: UIViewController>(type: T.Type, animated: Bool = true) {
        unwindToLast(animated: animated, where: {$0 is T})
    }

    func unwindToFirst(animated: Bool = true, where predicate: (UIViewController) -> Bool) {
        guard let controller = findFirst(where: predicate) else {
            print("Unable to find view controller")
            return
        }

        unwindToController(controller, animated: animated)
    }

    func unwindToLast(animated: Bool = true, where predicate: (UIViewController) -> Bool) {
        guard let controller = findLast(where: predicate) else {
            print("Unable to find view controller")
            return
        }

        unwindToController(controller, animated: animated)
    }

    func unwindToController(_ controller: UIViewController, animated: Bool = true) {
        if controller.presentedViewController != nil {
            controller.dismiss(animated: animated, completion: nil)
        }

        if controller is UINavigationController {
            return
        }

        if let navigationController = controller.navigationController {
            if navigationController.viewControllers.contains(controller) {
                navigationController.popToViewController(controller, animated: animated)
            }
        }
    }
}
