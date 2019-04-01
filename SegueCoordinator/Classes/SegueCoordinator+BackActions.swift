//
//  SegueCoordinator+BackActions.swift
//  Pods-SegueCoordinator_Example
//
//  Created by Евгений Сафронов on 01/04/2019.
//

import UIKit

public extension SegueCoordinator {
    /**
     Dismiss current modal view controller.

     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     - Parameter completion: The block to execute after the view controller is dismissed.
     */

    func closeModal(animated: Bool = true, _ completion: @escaping (() -> Void) = {}) {
        currentController.dismiss(animated: animated, completion: completion)
    }

    /**
     Pops view controller from the stack of the current navigation controller.

     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     */

    func pop(animated: Bool = true) {
        currentNavigationController.popViewController(animated: animated)
    }

    /**
     Pops view controllers from current navigation controller until the specified view controller is at the top of the navigation stack.

     - Parameter animated: Specify true to animate the transition. Otherwise, specify false.
     */

    func popToController(_ controller: UIViewController, animated: Bool = true) {
        currentNavigationController.popToViewController(controller, animated: animated)
    }

}
