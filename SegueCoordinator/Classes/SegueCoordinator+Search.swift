//
//  SegueCoordinator+Search.swift
//  Pods-SegueCoordinator_Example
//
//  Created by Евгений Сафронов on 01/04/2019.
//

import UIKit

public extension SegueCoordinator {

    func findFirst<T: UIViewController>(type: T) -> T? {
        return findFirst(where: { $0 is T }) as? T
    }

    func findFirst(where predicate: (UIViewController) -> Bool) -> UIViewController? {
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

    func findLast<T: UIViewController>(type: T) -> T? {
        return findLast(where: { $0 is T }) as? T
    }

    func findLast(where predicate: (UIViewController) -> Bool) -> UIViewController? {
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
}
