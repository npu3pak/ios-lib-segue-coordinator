
import UIKit

// MARK: Modal

public extension SegueCoordinator {
    /**
     Create the initial view controller from the storyboard and present it modally from the current navigation controller.

     - Parameter type: Expected type of view controller.
     - Parameter style: Modal presentation style.
     - Parameter wrapInNavigationController: Specify true if you want to wrap modal controller in it's own navigation controller. Otherwise, specify false.
     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     - Parameter prepareController: The block to execute after controller will be created.
     Pass any data and dependencies into view controller here.
     - Parameter controller: Created view controller
     */

    func modalInitial<T: UIViewController>(type: T.Type, style: UIModalPresentationStyle, wrapInNavigationController: Bool = true, animated: Bool = true, prepareController: (_ controller: T) -> Void) {
        let controller = storyboard.instantiateInitialViewController() as! T
        modalController(controller, style: style, wrapInNavigationController: wrapInNavigationController, animated: animated, prepareController: prepareController)
    }

    /**
     Create the view controller from the storyboard by identifier and present it modally from the current navigation controller.

     - Parameter storyboardId: Storyboard ID of view controller specified with identity inspector in Interface Builder.
     - Parameter type: Expected type of view controller.
     - Parameter style: Modal presentation style.
     - Parameter wrapInNavigationController: Specify true if you want to wrap modal controller in it's own navigation controller. Otherwise, specify false.
     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     - Parameter prepareController: The block to execute after controller will be created.
     Pass any data and dependencies into view controller here.
     - Parameter controller: Created view controller
     */

    func modal<T: UIViewController>(_ storyboardId: String, type: T.Type, style: UIModalPresentationStyle, wrapInNavigationController: Bool = true, animated: Bool = true, prepareController: (_ controller: T) -> Void) {
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        modalController(controller, style: style, wrapInNavigationController: wrapInNavigationController, animated: animated, prepareController: prepareController)
    }

    /**
     Present controller modally from the current navigation controller.

     - Parameter controller: Controller to be presented.
     - Parameter style: Modal presentation style.
     - Parameter wrapInNavigationController: Specify true if you want to wrap modal controller in it's own navigation controller. Otherwise, specify false.
     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     - Parameter prepareController: The block to execute before controller will be presented.
     Pass any data and dependencies into view controller here.
     - Parameter controller: Controller to be presented.
     */

    func modalController<T: UIViewController>(_ controller: T, style: UIModalPresentationStyle, wrapInNavigationController: Bool = true, animated: Bool = true, prepareController: (_ controller: T) -> Void) {
        if wrapInNavigationController {
            let modalNavController = UINavigationController(rootViewController: controller)
            modalNavController.modalPresentationStyle = style
            // We should wrap before preparation callback to give access to modal navigationController from prepareController()
            prepareController(controller)
            topController.present(modalNavController, animated: animated, completion: nil)
        } else {
            controller.modalPresentationStyle = style
            prepareController(controller)
            topController.present(controller, animated: animated, completion: nil)
        }
    }
}
