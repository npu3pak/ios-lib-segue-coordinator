
import UIKit

// MARK: Instantiate

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
}
