
import UIKit

public extension SegueCoordinator {
    /**
     Create initial view controller from storyboard.

     - Parameter type: Expected type of view controller.
     */

    func instantiateInitial<T: UIViewController>(type: T.Type) -> T {
        return storyboard.instantiateInitialViewController() as! T
    }

    /**
     Create view controller from storyboard by identifier.

     - Parameter storyboardId: Storyboard ID of view controller specified with identity inspector in Interface Builder.
     - Parameter type: expected Type of view controller.
     */

    func instantiate<T: UIViewController>(_ storyboardId: String, type: T.Type) -> T {
        return storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
    }

    // MARK: - Set

    /**
     Create the initial view controller from the storyboard and make it the root of the current navigation controller.
     All other presented controllers will be removed from navigation stack.

     - Parameter type: Expected type of view controller.
     - Parameter prepareController: The block to execute after controller will be created.
     Pass any data and dependencies into view controller here.
     - Parameter controller: Created view controller
     */

    func setInitial<T: UIViewController>(type: T.Type, prepareController: (_ controller: T) -> Void) {
        let controller = storyboard.instantiateInitialViewController() as! T
        setController(controller, prepareController: prepareController)
    }
}
