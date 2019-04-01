
import UIKit

public extension SegueCoordinator {
    /**
     Create the initial view controller from the storyboard and push it to the stack of the current navigation controller.

     - Parameter type: Expected type of view controller.
     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     - Parameter prepareController: The block to execute after controller will be created.
     Pass any data and dependencies into view controller here.
     - Parameter controller: Created view controller
     */

    func pushInitial<T: UIViewController>(type: T.Type, animated: Bool = true, prepareController: (_ controller: T) -> Void) {
        let controller = storyboard.instantiateInitialViewController() as! T
        pushController(controller, animated: animated, prepareController: prepareController)
    }

    /**
     Create the view controller from the storyboard by identifier and push it to the stack of the current navigation controller.

     - Parameter storyboardId: Storyboard ID of view controller specified with identity inspector in Interface Builder.
     - Parameter type: Expected type of view controller.
     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     - Parameter prepareController: The block to execute after controller will be created.
     Pass any data and dependencies into view controller here.
     - Parameter controller: Created view controller
     */

    func push<T: UIViewController>(_ storyboardId: String, type: T.Type, animated: Bool = true, prepareController: (T) -> Void) {
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        pushController(controller, animated: animated, prepareController: prepareController)
    }

    /**
     Push view controller to the stack of the current navigation controller.

     - Parameter controller: Controller to be presented.
     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     - Parameter prepareController: The block to execute before controller will be presented.
     Pass any data and dependencies into view controller here.
     - Parameter controller: Controller to be presented.
     */

    func pushController<T: UIViewController>(_ controller: T, animated: Bool = true, prepareController: (_ controller: T) -> Void) {
        prepareController(controller)
        currentNavigationController.pushViewController(controller, animated: animated)
    }
}

