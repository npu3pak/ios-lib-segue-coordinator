
import UIKit
import ObjectiveC

public extension SegueCoordinator {
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

    func segue<T: UIViewController>(_ segueId: String, type: T.Type, prepareController: @escaping (_ controller: T) -> Void) {
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

extension UIViewController {
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
