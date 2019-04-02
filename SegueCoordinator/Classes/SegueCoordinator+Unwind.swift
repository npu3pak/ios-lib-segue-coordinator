
import UIKit

// MARK: Unwind

public extension SegueCoordinator {
    /**
      This method will make a transition to the farthest matching controller. It performs searching for the first view controller matching the specified type. Then it closes all modal view controllers above the found view controller's stack and pops navigation stack to make the found view controller the top. In other words, the found view controller becomes the top and visible.

     - Parameter type: Type of required view controller.
     - Parameter animated: specify true if you want to animate the transition. Specify false otherwise.
     */
    func unwindToFirst<T: UIViewController>(type: T.Type, animated: Bool = true) {
        unwindToFirst(animated: animated, where: {$0 is T})
    }

    /**
     This method will make a transition to the closest matching controller. It performs searching for the last view controller matching the specified type. Then it closes all modal view controllers above the found view controller's stack and pops navigation stack to make the found view controller the top. In other words, the found view controller becomes the top and visible.

     - Parameter type: Type of required view controller.
     - Parameter animated: specify true if you want to animate the transition. Specify false otherwise.
     */
    func unwindToLast<T: UIViewController>(type: T.Type, animated: Bool = true) {
        unwindToLast(animated: animated, where: {$0 is T})
    }

    /**
     This method will make a transition to the farthest matching controller. It performs searching for the first view controller matching the specified predicate. Then it closes all modal view controllers above the found view controller's stack and pops navigation stack to make the found view controller the top. In other words, the found view controller becomes the top and visible.

     - Parameter animated: specify true if you want to animate the transition. Specify false otherwise.
     - Parameter predicate: Searching conditions. Returns true if the view controller passed in its argument fulfills conditions of the search. Returns false otherwise.
     - Parameter controller: Controller to check for the searching conditions.
     */
    func unwindToFirst(animated: Bool = true, where predicate: (UIViewController) -> Bool) {
        guard let controller = findFirst(where: predicate) else {
            print("Unable to find view controller")
            return
        }

        unwindToController(controller, animated: animated)
    }

    /**
     This method will make a transition to the closest matching controller. It performs searching for the last view controller matching the specified predicate. Then it closes all modal view controllers above the found view controller's stack and pops navigation stack to make the found view controller the top. In other words, the found view controller becomes the top and visible.

     - Parameter animated: specify true if you want to animate the transition. Specify false otherwise.
     - Parameter predicate: Searching conditions. Returns true if the view controller passed in its argument fulfills conditions of the search. Returns false otherwise.
     - Parameter controller: Controller to check for the searching conditions.
     */
    func unwindToLast(animated: Bool = true, where predicate: (_ controller: UIViewController) -> Bool) {
        guard let controller = findLast(where: predicate) else {
            print("Unable to find view controller")
            return
        }

        unwindToController(controller, animated: animated)
    }

    /**
     Closes all modal view controllers above the specified view controller's stack and pops navigation stack to make it the top. In other words, the specified view controller becomes the top and visible.

     - Parameter controller: controller to navigate to
     - Parameter animated: specify true if you want to animate the transition. Specify false otherwise.
    */
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
