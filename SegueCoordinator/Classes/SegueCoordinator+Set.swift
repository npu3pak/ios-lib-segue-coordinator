
import UIKit

public extension SegueCoordinator {
    /**
     Create the view controller from the storyboard by identifier and make it the root of the current navigation controller.
     All other presented controllers will be removed from navigation stack.

     - Parameter storyboardId: Storyboard ID of view controller specified with identity inspector in Interface Builder.
     - Parameter type: Expected type of view controller.
     - Parameter prepareController: The block to execute after controller will be created.
     Pass any data and dependencies into view controller here.
     - Parameter controller: Created view controller
     */

    func set<T: UIViewController>(_ storyboardId: String, type: T.Type, prepareController: (_ controller: T) -> Void) {
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        setController(controller, prepareController: prepareController)
    }

    /**
     Make view controller the root of the current navigation controller.
     All other presented controllers will be removed from navigation stack.

     - Parameter controller: Controller to be presented.
     - Parameter prepareController: The block to execute before controller will be presented.
     Pass any data and dependencies into view controller here.
     - Parameter controller: Controller to be presented
     */

    func setController<T: UIViewController>(_ controller: T, prepareController: (_ controller: T) -> Void) {
        prepareController(controller)
        topNavigationController.viewControllers = [controller]
    }

}
