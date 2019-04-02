
import UIKit

/**
 Builds on top of the storyboard and encapsulates navigation logic. View controllers delegates navigation requests to it and SegueCoordinator performs all required transitions as well as data transfer. Typically you should use its subclasses instead.
*/

open class SegueCoordinator {

    // MARK: Public properties

    /**
     Reference to the storyboard the SegueCoordinator work with.
    */
    public let storyboard: UIStoryboard

    /**
     Root navigation controller that was passed into initializer of SegueCoordinator.
     */
    public let rootNavigationController: UINavigationController

    var seguePreparationActions = [String: (UIViewController) -> Void]()

    // MARK: Initializers

    /**
     Typically, you should override this initializer and specify storyboard name.

     ### Example: ###
     ````
     init(navController: UINavigationController) {
        super.init(storyboardName: "Main", rootNavigationController: navController)
     }
     ````

     - Parameter storyboardName: Name of the storyboard the coordinator will work with.
     - Parameter rootNavigationController: Navigation controller for displaying controllers created by coordinator.
     */

    public init(storyboardName: String, rootNavigationController: UINavigationController) {
        UIViewController.swizzlePrepareForSegue()

        self.rootNavigationController = rootNavigationController

        let bundle = Bundle(for: type(of: self))
        storyboard = UIStoryboard.init(name: storyboardName, bundle: bundle)
    }
}
