
import UIKit

// MARK: Back actions

public extension SegueCoordinator {
    /**
     Dismiss current modal view controller.

     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     - Parameter completion: The block to execute after the view controller is dismissed.
     */

    func closeModal(animated: Bool = true, _ completion: @escaping (() -> Void) = {}) {
        topController.dismiss(animated: animated, completion: completion)
    }

    /**
     Pops view controller from the stack of the current navigation controller.

     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     */

    func pop(animated: Bool = true) {
        topNavigationController.popViewController(animated: animated)
    }

    /**
     Pops view controllers from current navigation controller until the specified view controller is at the top of the navigation stack.

     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     */

    func popToController(_ controller: UIViewController, animated: Bool = true) {
        topNavigationController.popToViewController(controller, animated: animated)
    }

}
