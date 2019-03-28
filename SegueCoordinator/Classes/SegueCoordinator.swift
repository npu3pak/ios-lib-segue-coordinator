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

    public init(storyboardName: String, rootNavigationController: UINavigationController) {
        UIViewController.swizzlePrepareForSegue()

        self.rootNavigationController = rootNavigationController

        let bundle = Bundle(for: type(of: self))
        storyboard = UIStoryboard.init(name: storyboardName, bundle: bundle)
    }

    // MARK: - Instantiate

    public func instantiateInitial<T: UIViewController>(type: T.Type) -> T {
        return storyboard.instantiateInitialViewController() as! T
    }

    public func instantiate<T: UIViewController>(_ storyboardId: String, type: T.Type) -> T {
        return storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
    }

    // MARK: - Set

    public func setInitial<T: UIViewController>(type: T.Type, prepareController: (T) -> Void) {
        let controller = storyboard.instantiateInitialViewController() as! T
        setController(controller, prepareController: prepareController)
    }

    public func set<T: UIViewController>(_ controllerId: String, type: T.Type, prepareController: (T) -> Void) {
        let controller = storyboard.instantiateViewController(withIdentifier: controllerId) as! T
        setController(controller, prepareController: prepareController)
    }

    public func setController<T: UIViewController>(_ controller: T, prepareController: (T) -> Void) {
        prepareController(controller)
        rootNavigationController.viewControllers = [controller]
    }

    // MARK: - Push

    public func pushInitial<T: UIViewController>(type: T.Type, animated: Bool = true, prepareController: (T) -> Void) {
        let controller = storyboard.instantiateInitialViewController() as! T
        pushController(controller, animated: animated, prepareController: prepareController)
    }

    public func push<T: UIViewController>(_ controllerId: String, type: T.Type, animated: Bool = true, prepareController: (T) -> Void) {
        let controller = storyboard.instantiateViewController(withIdentifier: controllerId) as! T
        pushController(controller, animated: animated, prepareController: prepareController)
    }

    public func pushController<T: UIViewController>(_ controller: T, animated: Bool = true, prepareController: (T) -> Void) {
        prepareController(controller)
        rootNavigationController.pushViewController(controller, animated: animated)
    }

    // MARK: - Modal

    public func modalInitial<T: UIViewController>(type: T.Type, style: UIModalPresentationStyle = .formSheet, animated: Bool = true, prepareController: (T) -> Void) {
        let controller = storyboard.instantiateInitialViewController() as! T
        modalController(controller, style: style, animated: animated, prepareController: prepareController)
    }

    public func modal<T: UIViewController>(_ controllerId: String, type: T.Type, style: UIModalPresentationStyle, animated: Bool = true, prepareController: (T) -> Void) {
        let controller = storyboard.instantiateViewController(withIdentifier: controllerId) as! T
        modalController(controller, style: style, animated: animated, prepareController: prepareController)
    }

    public func modalController<T: UIViewController>(_ controller: T, style: UIModalPresentationStyle, animated: Bool = true, prepareController: (T) -> Void) {
        let modalNavController = UINavigationController(rootViewController: controller)
        modalNavController.modalPresentationStyle = style
        // We must allow to get modal navigationController from prepareController()
        prepareController(controller)
        rootNavigationController.present(modalNavController, animated: animated, completion: nil)
    }

    // MARK: - Segue

    public func segue<T: UIViewController>(_ segueId: String, type: T.Type, prepareController: @escaping (T) -> Void) {
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

    public func closeModal(animated: Bool = true, _ completion: @escaping (() -> Void) = {}) {
        currentController.dismiss(animated: animated, completion: completion)
    }

    public func pop(animated: Bool = true) {
        rootNavigationController.popViewController(animated: animated)
    }

    public func popToController(_ controller: UIViewController, animated: Bool = true) {
        rootNavigationController.popToViewController(controller, animated: animated)
    }

    // MARK: - Utility

    public var currentController: UIViewController {
        return rootNavigationController.viewControllers.last!
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
