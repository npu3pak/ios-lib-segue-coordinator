
import UIKit

open class SegueCoordinator {

    // MARK: Properties

    public let storyboard: UIStoryboard
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
