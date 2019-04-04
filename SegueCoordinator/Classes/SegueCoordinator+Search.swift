
import UIKit

// MARK: Search

public extension SegueCoordinator {
    /**
     This method will search the controller by its type. Search for view controller is starting on the navigation stack of the root navigation controller. Then the search continues on the navigation stack of the presented view controller and so on. This method will return the first view controller that will fulfill the conditions of the search. In other words, it returns the farthest to the current view controller in the navigation stack.

     - Parameter type: Type of required view controller.
     - Returns: view controller if it was found, nil otherwise.
    */

    func findFirst<T: UIViewController>(type: T.Type) -> T? {
        return findFirst(where: { $0 is T }) as? T
    }

    /**
     This method will search the controller with custom conditions declared in the predicate. Search for view controller is starting on the navigation stack of the root navigation controller. Then the search continues on the navigation stack of the presented view controller and so on. This method will return the first view controller that will fulfill the conditions of the search. In other words, it returns the farthest to the current view controller in the navigation stack.

     - Parameter predicate: Searching conditions. Returns true if the view controller passed in its argument fulfills conditions of the search. Returns false otherwise.
     - Parameter controller: Controller to check for the searching conditions.
     - Returns: view controller if it was found, nil otherwise.
     */
    func findFirst(where predicate: (_ controller: UIViewController) -> Bool) -> UIViewController? {
        var controller: UIViewController? = rootNavigationController

        repeat {
            if predicate(controller!) {
                return controller!
            }
            if let navigationController = controller as? UINavigationController {
                if let target = navigationController.viewControllers.first(where: predicate) {
                    return target
                }
            }
            controller = controller?.presentedViewController
        } while controller != nil

        return nil
    }

    /**
     This method will search the controller by its type. Search for view controller starting on the navigation stack of the root navigation controller. Search for view controller is starting on the navigation stack of the root navigation controller. Then the search continues on the navigation stack of the presented view controller and so on. This method will return the last view controller that will fulfill the conditions of the search. In other words, it returns the nearest to the current view controller in the navigation stack.

     - Parameter type: Type of required view controller.
     - Returns: view controller if it was found, nil otherwise.
     */
    func findLast<T: UIViewController>(type: T.Type) -> T? {
        return findLast(where: { $0 is T }) as? T
    }

    /**
     This method will search the controller with custom conditions declared in the predicate. Search for view controller is starting on the navigation stack of the root navigation controller. Then the search continues on the navigation stack of the presented view controller and so on. This method will return the last view controller that will fulfill the conditions of the search. In other words, it returns the nearest to the current view controller in the navigation stack.

     - Parameter predicate: Searching conditions. Returns true if the view controller passed in its argument fulfills conditions of the search. Returns false otherwise.
     - Parameter controller: Controller to check for the searching conditions.
     - Returns: view controller if it was found, nil otherwise.
     */
    func findLast(where predicate: (_ controller: UIViewController) -> Bool) -> UIViewController? {
        var result: UIViewController?
        var controller: UIViewController? = rootNavigationController

        repeat {
            if predicate(controller!) {
                result = controller!
            }
            if let navigationController = controller as? UINavigationController {
                if let target = navigationController.viewControllers.last(where: predicate) {
                    result = target
                }
            }
            controller = controller?.presentedViewController
        } while controller != nil

        return result
    }
}
