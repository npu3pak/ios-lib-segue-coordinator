//
//  SegueCoordinator.swift
//  Pods
//
//  Created by Евгений Сафронов on 25.01.17.
//

import UIKit
import ObjectiveC

open class SegueCoordinator {

    public let storyboard: UIStoryboard
    public let rootNavigationController: UINavigationController

    private var seguePreparationActions = [String: (UIViewController) -> Void]()

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

    // MARK: - Instantiate

    /**
     Create initial view controller from storyboard.

     - Parameter type: Expected type of view controller.
    */

    public func instantiateInitial<T: UIViewController>(type: T.Type) -> T {
        return storyboard.instantiateInitialViewController() as! T
    }

    /**
     Create view controller from storyboard by identifier.

     - Parameter storyboardId: Storyboard ID of view controller specified with identity inspector in Interface Builder.
     - Parameter type: expected Type of view controller.
     */

    public func instantiate<T: UIViewController>(_ storyboardId: String, type: T.Type) -> T {
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

    public func setInitial<T: UIViewController>(type: T.Type, prepareController: (_ controller: T) -> Void) {
        let controller = storyboard.instantiateInitialViewController() as! T
        setController(controller, prepareController: prepareController)
    }

    /**
     Create the view controller from the storyboard by identifier and make it the root of the current navigation controller.
     All other presented controllers will be removed from navigation stack.

     - Parameter storyboardId: Storyboard ID of view controller specified with identity inspector in Interface Builder.
     - Parameter type: Expected type of view controller.
     - Parameter prepareController: The block to execute after controller will be created.
     Pass any data and dependencies into view controller here.
     - Parameter controller: Created view controller
     */

    public func set<T: UIViewController>(_ storyboardId: String, type: T.Type, prepareController: (_ controller: T) -> Void) {
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

    public func setController<T: UIViewController>(_ controller: T, prepareController: (_ controller: T) -> Void) {
        prepareController(controller)
        currentNavigationController.viewControllers = [controller]
    }

    // MARK: - Push

    /**
     Create the initial view controller from the storyboard and push it to the stack of the current navigation controller.

     - Parameter type: Expected type of view controller.
     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     - Parameter prepareController: The block to execute after controller will be created.
     Pass any data and dependencies into view controller here.
     - Parameter controller: Created view controller
     */

    public func pushInitial<T: UIViewController>(type: T.Type, animated: Bool = true, prepareController: (_ controller: T) -> Void) {
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

    public func push<T: UIViewController>(_ storyboardId: String, type: T.Type, animated: Bool = true, prepareController: (T) -> Void) {
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

    public func pushController<T: UIViewController>(_ controller: T, animated: Bool = true, prepareController: (_ controller: T) -> Void) {
        prepareController(controller)
        currentNavigationController.pushViewController(controller, animated: animated)
    }

    // MARK: - Modal

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

    public func modalInitial<T: UIViewController>(type: T.Type, style: UIModalPresentationStyle, wrapInNavigationController: Bool = true, animated: Bool = true, prepareController: (_ controller: T) -> Void) {
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

    public func modal<T: UIViewController>(_ storyboardId: String, type: T.Type, style: UIModalPresentationStyle, wrapInNavigationController: Bool = true, animated: Bool = true, prepareController: (_ controller: T) -> Void) {
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

    public func modalController<T: UIViewController>(_ controller: T, style: UIModalPresentationStyle, wrapInNavigationController: Bool = true, animated: Bool = true, prepareController: (_ controller: T) -> Void) {
        if wrapInNavigationController {
            let modalNavController = UINavigationController(rootViewController: controller)
            modalNavController.modalPresentationStyle = style
            // We should wrap before preparation callback to give access to modal navigationController from prepareController()
            prepareController(controller)
            currentNavigationController.present(modalNavController, animated: animated, completion: nil)
        } else {
            controller.modalPresentationStyle = style
            prepareController(controller)
            currentNavigationController.present(controller, animated: animated, completion: nil)
        }
    }

    // MARK: - Segue

    /**
     Perform segue from currently presented view controller

     - Parameter segueId: Segue Identifier specified with Attributes Inspector in Interface Builder
     - Parameter type: Expected type of destination view controller.
     - Parameter prepareController: The block to execute before controller will be presented. This is prepareForSegue replacement.
     Pass any data and dependencies into view controller here.
     - Parameter controller: Controller to be presented.

     - Warning: If you override prepareForSegue method, be sure to call super.prepareForSegue

     ````
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
     }
     ````
     */

    public func segue<T: UIViewController>(_ segueId: String, type: T.Type, prepareController: @escaping (_ controller: T) -> Void) {
        segue(segueId) {
            prepareController($0 as! T)
        }
    }

    private func segue(_ segueId: String, prepareController: @escaping (UIViewController) -> Void) {
        seguePreparationActions[segueId] = prepareController

        do {
            try NSExceptionCatch.catchException {
                self.currentController.pendingSegueCoordinator = self
                self.currentController.performSegue(withIdentifier: segueId, sender: self)
            }
        } catch _ {
            currentController.pendingSegueCoordinator = nil
            seguePreparationActions.removeValue(forKey: segueId)
            print("Unable to execute segue \(segueId) from \(currentController)")
        }
    }

    fileprivate func prepareForSegue(_ segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier, let action = seguePreparationActions[segueId] else {
            return
        }

        seguePreparationActions.removeValue(forKey: segueId)
        currentController.pendingSegueCoordinator = nil

        let nextController: UIViewController
        if let targetNavigationController = segue.destination as? UINavigationController {
            nextController = targetNavigationController.viewControllers[0]
        } else {
            nextController = segue.destination
        }

        action(nextController)
    }

    // MARK: - Back actions

    /**
     Dismiss current modal view controller.

     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     - Parameter completion: The block to execute after the view controller is dismissed.
     */

    public func closeModal(animated: Bool = true, _ completion: @escaping (() -> Void) = {}) {
        currentController.dismiss(animated: animated, completion: completion)
    }

    /**
     Pops view controller from the stack of the current navigation controller.

     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     */

    public func pop(animated: Bool = true) {
        currentNavigationController.popViewController(animated: animated)
    }

    /**
     Pops view controllers from current navigation controller until the specified view controller is at the top of the navigation stack.

     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     */

    public func popToController(_ controller: UIViewController, animated: Bool = true) {
        currentNavigationController.popToViewController(controller, animated: animated)
    }

    // MARK: - Unwind

    public func unwindToFirst<T: UIViewController>(type: T.Type, animated: Bool = true) {
        unwindToFirst(animated: animated, where: {$0 is T})
    }

    public func unwindToLast<T: UIViewController>(type: T.Type, animated: Bool = true) {
        unwindToLast(animated: animated, where: {$0 is T})
    }

    public func unwindToFirst(animated: Bool = true, where predicate: (UIViewController) -> Bool) {
        guard let controller = findFirst(where: predicate) else {
            print("Unable to find view controller")
            return
        }

        unwindToController(controller, animated: animated)
    }

    public func unwindToLast(animated: Bool = true, where predicate: (UIViewController) -> Bool) {
        guard let controller = findLast(where: predicate) else {
            print("Unable to find view controller")
            return
        }

        unwindToController(controller, animated: animated)
    }

    public func unwindToController(_ controller: UIViewController, animated: Bool = true) {
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

    // MARK: - Search

    public func findFirst<T: UIViewController>(type: T) -> T? {
        return findFirst(where: { $0 is T }) as? T
    }

    public func findFirst(where predicate: (UIViewController) -> Bool) -> UIViewController? {
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

    public func findLast<T: UIViewController>(type: T) -> T? {
        return findLast(where: { $0 is T }) as? T
    }

    public func findLast(where predicate: (UIViewController) -> Bool) -> UIViewController? {
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

    // MARK: - Utility

    public var currentController: UIViewController {
        // View controllers are presented from Navigation Controller if it exists
        var controller: UIViewController = rootNavigationController

        while let presented = controller.presentedViewController {
            controller = presented
        }

        if let topNavigationController = controller as? UINavigationController {
            return topNavigationController.viewControllers.last ?? topNavigationController
        } else {
            return controller
        }
    }

    public var currentNavigationController: UINavigationController {
        var navigationController = rootNavigationController
        var controller: UIViewController = rootNavigationController

        while let presented = controller.presentedViewController {
            if presented is UINavigationController {
                navigationController = presented as! UINavigationController
            }
            controller = presented
        }
        return navigationController
    }
}

// MARK: - Swizzling of prepareForSegue

private var segueCoordinatorPropertyHandle: UInt8 = 0

private let swizzling: () = {
    let originalSelector = #selector(UIViewController.prepare(for:sender:))
    let swizzledSelector = #selector(UIViewController.swizzled_prepare(for:sender:))

    let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
    let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)

    method_exchangeImplementations(originalMethod!, swizzledMethod!)
}()

fileprivate extension UIViewController {
    static func swizzlePrepareForSegue() {
        _ = swizzling
    }

    // weak reference
    var pendingSegueCoordinator: SegueCoordinator? {
        get {
            return objc_getAssociatedObject(self, &segueCoordinatorPropertyHandle) as? SegueCoordinator
        }
        set {
            objc_setAssociatedObject(self, &segueCoordinatorPropertyHandle, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    @objc func swizzled_prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.swizzled_prepare(for: segue, sender: sender)
        pendingSegueCoordinator?.prepareForSegue(segue, sender: sender)
    }
}
